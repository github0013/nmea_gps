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
      attr_accessor :gps_serial_port, :update_hz, :callbacks, :track_thread

    private

      def hz
        self.update_hz
      end

      def frequency
        sleep hz
      end

      def line_set
        Hash.new{|hash, key| hash[key] = [] }.tap do |set|
          loop do 
            line = self.gps_serial_port.gets("\r\n").strip
            #                   %w[ GLL RMC VTG GGA GSA GSV ZDA].join.chars.uniq.sort.join
            next unless match = line.match(/\A\$#{TALKER_ID}([ACDGLMRSTVZ]{3})/)
            
            sentence = match[1].downcase.to_sym
            set[sentence] << line
            break if sentence == :gga
          end
        end
      end

      def callback!
        this_set = line_set
        this_set.keys.each do |sentence|
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

          this_callback.call object # TODO: error handling
        end
      end


  end
end
