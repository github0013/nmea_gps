module Nmea
  class Gps

    class SentenceBase

      STATUSES = {
        "A" => :valid,
        "V" => :invalid,
      }

      MODES = {
        "A" => :autonomous,
        "N" => :no_fix,
        "D" => :dgps,
        "E" => :dr,
      }


      def initialize(line)
        @line = line
      end

      def name
        raise "override this method"
      end

      def raw_data
        _, *data = self.line.split("*").first.split(",")
        data
      end

      protected
        attr_reader :line

    end
  end
end