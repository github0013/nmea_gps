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

      attr_reader :raw_sentence_line

      def initialize(raw_sentence_line)
        @raw_sentence_line = raw_sentence_line
      end

      def name
        raise "override this method"
      end

      def raw_data
        _, *data = self.raw_sentence_line.split("*").first.split(",")
        data
      end

    end
  end
end