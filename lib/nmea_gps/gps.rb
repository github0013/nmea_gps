module Nmea

  class Gps
    TALKER_ID = "GP"

    def initialize(serial_port, hz: 1)
      self.callbacks        = {}
      self.gps_serial_port  = serial_port
      self.update_hz        = 1.second.to_f / (hz.to_i.zero? ? 1 : hz.to_i)
    end

    Dir[Pathname(__FILE__).join("../sentences/*.rb")].collect do |path|
      Pathname(path).basename(".rb").to_s
    end.tap{|array| array << "error" }.each do |sentence|
      define_method(sentence) do |&block|
        self.callbacks[__callee__] = block
      end
    end

    def track!
      self.track_thread = Thread.new do 
        loop do 
          callback!
          frequency
        end
      end
    end

    def stop!
      self.track_thread.kill if self.track_thread.respond_to? :kill
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

      def ensure_sentence
        yield *@buffer if @buffer

        raw_sentence_line = self.gps_serial_port.gets("\r\n").strip
        #                   %w[ GLL RMC VTG GGA GSA GSV ZDA].join.chars.uniq.sort.join
        return unless match = raw_sentence_line.match(/\A\$#{TALKER_ID}([ACDGLMRSTVZ]{3})/)
        
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
            this_callback = self.callbacks[sentence]
            next unless this_callback

            target_class = "Nmea::Gps::#{sentence.to_s.camelcase}".constantize

            object = if sentence == :gsv
                    raw_sentence_lines_in_array.sort.collect do |raw_sentence|
                      target_class.new raw_sentence
                    end
                  else
                    target_class.new(raw_sentence_lines_in_array.first)
                  end

            this_callback.call object
          rescue => ex
            self.callbacks[:error].call ex
          end
        end

      rescue => ex
        self.callbacks[:error].call ex
      end


  end
end
