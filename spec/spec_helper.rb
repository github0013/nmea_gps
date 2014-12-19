$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'timecop'
require 'nmea_gps'

TIMECOP_2014_01_01__0_00_00 = 1388534400

RSpec.configure do |config|
  # config.filter_run :focus
end
