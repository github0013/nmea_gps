module Nmea
  class Gps

    class Rmc < SentenceBase
      include Nmea::UtcTimeable, Nmea::DddFormatable

      def name
        "Recommended minimum specific GNSS data"
      end

      def time
        hhmmss_to_local_time raw_data[0]
      end

      def status
        STATUSES[raw_data[1]]
      end

      def latitude
        dmm_to_ddd raw_data[2], raw_data[3]
      end

      def longitude
        dmm_to_ddd raw_data[4], raw_data[5]
      end

      def knot_per_hour
        raw_data[6].to_f
      end

      def km_per_hour
        knot_per_hour * 1.85200
      end

      def mile_per_hour
        knot_per_hour * 1.15077945
      end

      def heading
        raw_data[7].to_f
      end

      def date
        _, day, month, year = raw_data[8].match(/(\d{2})(\d{2})(\d{2})/).to_a
        Date.parse("#{year}/#{month}/#{day}")
      end

      def magnetic_variation
        return nil if raw_data[9].blank?
        raw_data[9].to_f
      end

      def magnetic_variation_direction
        return nil if raw_data[10].blank?
        raw_data[10].to_f
      end

      def mode
        MODES[raw_data[11]]
      end


    end
  end
end
