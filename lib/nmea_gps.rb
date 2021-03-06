require "pathname"
require "serialport"
require "ostruct"

require 'active_support'
require 'active_support/core_ext'

require "nmea_gps/version"
require "nmea_gps/config"
require "nmea_gps/gps"

module Nmea

  module UtcTimeable
    protected
      def hhmmss_to_local_time(text)
        hh, mm, ss = text.chars.each_slice(2).collect{|chars| chars.join }
        Time.zone = "UTC"
        utc_today = Time.zone.today
        Time.zone.local(utc_today.year, utc_today.month, utc_today.day, hh, mm, ss).
          in_time_zone(Nmea::Config.time_zone)
      end
  end

  module DddFormatable
    protected
      def dmm_to_ddd(dmm, direction)
        dmm = dmm.to_f / 100
        integer = dmm.to_i
        decimal = dmm % 1

        (integer + decimal / 60  * 100.0) * ("NE".include?(direction) ? 1 : -1)
      end
  end

end

require "nmea_gps/sentence_base"
Dir[Pathname(__FILE__).join("../nmea_gps/sentences/*.rb")].each {|file| require file }
