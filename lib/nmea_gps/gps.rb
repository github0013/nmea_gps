module Nmea

  class Gps
    TALKER_ID = "GP"

    def initialize(serial_port, update_hz: 1)
      self.callbacks        = {}
      self.gps_serial_port  = serial_port
      self.update_hz        = 1.second.to_f / update_hz.to_i
    end

    Dir[Pathname(__FILE__).join("../sentences/*.rb")].collect do |path|
      Pathname(path).basename(".rb").to_s
    end.each do |sentence|
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

      def hz
        self.update_hz
      end

      def frequency
        sleep hz
      end

      def sentences_in_a_cycle
        Hash.new{|hash, key| hash[key] = [] }.tap do |set|
          catch(:done_one_revolution) do
            loop do 
              ensure_sentence do |sentence, line|
                set[sentence] << line
              end
            end
          end
        end
      end

      def ensure_sentence
        yield *@buffer if @buffer

        line = self.gps_serial_port.gets("\r\n").strip
        #                   %w[ GLL RMC VTG GGA GSA GSV ZDA].join.chars.uniq.sort.join
        return unless match = line.match(/\A\$#{TALKER_ID}([ACDGLMRSTVZ]{3})/)
        
        sentence = match[1].downcase.to_sym
        if sentence == self.initial_sentence
          @buffer = [sentence, line]
          throw :done_one_revolution 
        end

        yield sentence, line

        self.initial_sentence ||= sentence unless sentence == :gsv 
      end

      def callback!
        this_set = sentences_in_a_cycle
        this_set.keys.each do |sentence|
          # TODO: error handling / add a logger??
          begin
            this_callback = self.callbacks[sentence]
            next unless this_callback

            target_class = "Nmea::Gps::#{sentence.to_s.camelcase}".constantize

            object = if sentence == :gsv
                    this_set[sentence].sort.collect do |line|
                      target_class.new line
                    end
                  else
                    target_class.new(this_set[sentence].first)
                  end

            this_callback.call object
          rescue => ex
            puts "#{ex.message} sentence:#{sentence} / #{this_set[sentence]}"
            puts ex.backtrace.join "\n"
          end
        end
      end


  end
end
