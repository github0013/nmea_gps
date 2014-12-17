module Nmea
  class Gps

    class Gsa < SentenceBase

      MODE_SELECTIONS = {
        "M" => :manual,
        "A" => :automatic,
      }

      MODES = {
        "1" => :fix_not_available,
        "2" => :fix_2D,
        "3" => :fix_3D,
      }

      def name
        "GNSS DOP and active satellites"
      end

      def mode_selection
        MODE_SELECTIONS[raw_data[0]]
      end

      def mode
        MODES[raw_data[1]]
      end

      def ids_of_svs_used_in_position_fix(at = :all)
        ids = raw_data[2..13]
        return ids if at == :all
        
        id = ids[at.to_i - 1]
        return nil if id.blank?

        id.to_i
      end
      alias :svs_ids :ids_of_svs_used_in_position_fix

      def position_dilution_of_precision
        raw_data[14].to_f
      end
      alias :pdop :position_dilution_of_precision

      def horizontal_dilution_of_precision
        raw_data[15].to_f
      end
      alias :hdop :horizontal_dilution_of_precision

      def vertical_dilution_of_precision
        raw_data[16].to_f
      end
      alias :vdop :vertical_dilution_of_precision

    end
  end
end
