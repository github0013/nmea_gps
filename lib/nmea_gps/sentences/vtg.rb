module Nmea
  class Gps

    class Vtg < SentenceBase
      def name
        "Course over ground and ground speed"
      end

      def true_course
        raw_data[0].to_f
      end

      def magnetic_course
        return if raw_data[2].blank?
        raw_data[2].to_f
      end

      def knot_per_hour
        raw_data[4].to_f
      end

      def km_per_hour
        raw_data[6].to_f
      end
    end
  end
end
