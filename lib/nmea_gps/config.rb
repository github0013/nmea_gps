module Nmea
  class Config
    class << self
      attr_accessor :time_zone

      def time_zone_list
        TZInfo::Timezone.all_identifiers
      end
    end
  end
end