module Nmea
  class Gps

    class Zda < SentenceBase
      include Nmea::UtcTimeable

      def name
        "Date and Time"
      end

      def time
        hhmmss_to_local_time raw_data[0]
      end

      def date
        Date.parse("#{raw_data[3]}/#{raw_data[2]}/#{raw_data[1]}")
      end

      def local_zone_hours
        return if raw_data[4].blank?
        raw_data[4].to_i
      end

      def local_zone_minutes
        return if raw_data[5].blank?
        raw_data[5].to_i
      end

    end
  end
end
