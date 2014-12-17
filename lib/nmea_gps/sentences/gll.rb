module Nmea
  class Gps

    class Gll < SentenceBase
      include Nmea::UtcTimeable, Nmea::DddFormatable

      def name
        "Geographic position—latitude/longitude"
      end

      def latitude
        dmm_to_ddd raw_data[0], raw_data[1]
      end

      def longitude
        dmm_to_ddd raw_data[2], raw_data[3]
      end

      def time
        hhmmss_to_local_time raw_data[4]
      end

      def status
        STATUSES[raw_data[5]]
      end

      def mode
        MODES[raw_data[6]]
      end

    end
  end
end

