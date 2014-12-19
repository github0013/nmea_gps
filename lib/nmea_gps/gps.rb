module Nmea

  class Gps
    TALKER_ID = "GP".freeze
    SENTENCE_NAMES = Dir[Pathname(__FILE__).join("../sentences/*.rb")].collect do |path|
      Pathname(path).basename(".rb").to_s
    end.freeze

    def initialize(serial_port, hz: 1)
      self.callbacks        = {}
      self.gps_serial_port  = serial_port
      self.update_hz        = 1.second.to_f / (hz.to_i.zero? ? 1 : hz.to_i)
    end

    (SENTENCE_NAMES + %w[error all]).each do |sentence|
      define_method(sentence) do |&block|
        self.callbacks[__callee__] = block
      end

      define_method("clear_#{sentence}") do 
        self.callbacks.delete(sentence.to_sym)
      end
    end

    def track!
      return if self.track_thread

      self.track_thread = Thread.new do 
        loop do 
          callback!
          frequency
        end
      end
    end

    def stop!
      return unless self.track_thread.respond_to? :kill
      
      self.track_thread.kill 
      self.track_thread = nil
    end

    protected
      attr_accessor :gps_serial_port, :update_hz, :callbacks, :track_thread, :initial_sentence

    private

      def frequency
        sleep self.update_hz
      end

      def sentences_in_a_cycle
        Hash.new{|hash, key| hash[key] = [] }.tap do |set|
          catch(:done_one_cycle) do
            loop do 
              ensure_sentence do |sentence, raw_sentence_line|
                set[sentence] << raw_sentence_line
              end
            end
          end
        end
      end

      def sentence_name_reg
        @sentence_name_reg ||= /\A\$#{TALKER_ID}([#{SENTENCE_NAMES.join.chars.uniq.sort.join.upcase}]{3})/
      end

      def ensure_sentence
        yield *@buffer if @buffer

        raw_sentence_line = self.gps_serial_port.gets("\r\n").strip
        return unless match = raw_sentence_line.match(sentence_name_reg)
        
        sentence = match[1].downcase.to_sym
        if sentence == self.initial_sentence
          @buffer = [sentence, raw_sentence_line]
          throw :done_one_cycle 
        end

        yield sentence, raw_sentence_line

        self.initial_sentence ||= sentence unless sentence == :gsv 
      end

      def callback!
        sentences_in_a_cycle.each do |sentence, raw_sentence_lines_in_array|
          begin
            target_class = "Nmea::Gps::#{sentence.to_s.camelcase}".constantize

            object = if sentence == :gsv
                    raw_sentence_lines_in_array.sort.collect do |raw_sentence|
                      target_class.new raw_sentence
                    end
                  else
                    target_class.new(raw_sentence_lines_in_array.first)
                  end

            self.callbacks[sentence].call object         if self.callbacks[sentence]
            self.callbacks[:all].call [sentence, object] if self.callbacks[:all]
          rescue => ex
            self.callbacks[:error].call ex if self.callbacks[:error]
          end
        end

      rescue => ex
        self.callbacks[:error].call ex if self.callbacks[:error]
      end


  end
end
