module Nmea
  class Gps

    class Gsv < SentenceBase
      def name
        "GNSS satellites in view"
      end
      
      def number_of_message
        raw_data[0].to_i
      end

      def message_number
        raw_data[1].to_i
      end

      def number_of_satellites_in_view
        raw_data[2].to_i
      end

      def satellites
        raw_data[3..-1].each_slice(4).collect do |slice|
          OpenStruct.new.tap do |satellite|
            satellite.id                    = slice.first.to_i
            satellite.elevation             = slice[1].to_i
            satellite.azinmuth              = slice[2].to_i
            satellite.signal_to_noise_ratio = satellite.snr = slice.last.to_i
          end
        end
      end

    end
  end
end