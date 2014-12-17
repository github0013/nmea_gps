module Nmea
  class Gps

    class Gga < SentenceBase
      include Nmea::UtcTimeable, Nmea::DddFormatable

      QUALITIES = {
        0 => :invalid,
        1 => :gps_sps_fix,
        2 => :dgps_fix,
        3 => :gps_pps_fix,
      }

      def name
        "Global positioning system fixed data"
      end

      def time
        hhmmss_to_local_time raw_data[0]
      end

      def latitude
        dmm_to_ddd raw_data[1], raw_data[2]
      end

      def longitude
        dmm_to_ddd raw_data[3], raw_data[4]
      end

      def quality
        QUALITIES[raw_data[5].to_i]
      end

      def number_of_satellites
        raw_data[6].to_i
      end
      alias :satellites :number_of_satellites

      # http://en.wikipedia.org/wiki/Dilution_of_precision_%28GPS%29
      def horizontal_dilution_of_precision
        raw_data[7].to_f
      end
      alias :hdop :horizontal_dilution_of_precision

      def altitude_in_meters
        raw_data[8].to_f
      end
      alias :altitude :altitude_in_meters

      def height_of_geoid_above_wgs84_ellipsoid
        raw_data[10].to_f
      end
      alias :height_of_geoid :height_of_geoid_above_wgs84_ellipsoid

      def time_in_seconds_since_last_dgps_update
        raw_data[12].to_i
      end
      alias :last_dgps_update :time_in_seconds_since_last_dgps_update

      def dgps_station_id
        raw_data[13].to_s
      end

      def checksum
        raw_data[14].to_s
      end

    end
  end
end