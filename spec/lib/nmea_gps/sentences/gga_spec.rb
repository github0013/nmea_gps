require 'spec_helper'
require 'nmea_gps/sentences/gga'

describe Nmea::Gps::Gga do
  let(:line){ "$GPGGA,075247.000,3539.51480,N,13944.72598,E,1,8,0.97,-15.6,M,27.5,M,13,X*44" }
  subject{ Nmea::Gps::Gga.new line }

  describe "name" do
    it{ expect(subject.name).to eq "Global positioning system fixed data" }
  end

  describe "time" do
    # 2014/01/01 0:00:00
    before{ Timecop.freeze Time.zone.at(TIMECOP_2014_01_01__0_00_00) }
    after{ Timecop.return }

    it{ expect(subject.time).to eq Time.zone.parse("2014/01/01 07:52:47") }
    it{ expect(subject.time.zone).to eq "UTC" }
  end

  describe "latitude" do
    it{ expect(subject.latitude).to eq 35.65858 }
  end

  describe "longitude" do
    it{ expect(subject.longitude).to eq 139.74543299999996 }
  end

  describe "quality" do
    it{ expect(subject.quality).to eq :gps_sps_fix }
  end

  describe "number_of_satellites" do
    it{ expect(subject.number_of_satellites).to eq 8 }
  end

  describe "horizontal_dilution_of_precision" do
    it{ expect(subject.horizontal_dilution_of_precision).to eq 0.97 }
  end

  describe "altitude_in_meters" do
    it{ expect(subject.altitude_in_meters).to eq -15.6 }
  end

  describe "height_of_geoid_above_wgs84_ellipsoid" do
    it{ expect(subject.height_of_geoid_above_wgs84_ellipsoid).to eq 27.5 }
  end

  describe "time_in_seconds_since_last_dgps_update" do
    it{ expect(subject.time_in_seconds_since_last_dgps_update).to eq 13 }
  end

  describe "dgps_station_id" do
    it{ expect(subject.dgps_station_id).to eq "X" }
  end



end