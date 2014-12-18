require 'spec_helper'
require 'nmea_gps/sentences/rmc'
Time.zone = "UTC"

describe Nmea::Gps::Rmc do
  let(:line){ "$GPRMC,075333.000,A,3539.51480,N,13944.72598,E,32.84,151.55,171214,,,A*68" }
  subject{ Nmea::Gps::Rmc.new line }

  describe "name" do
    it{ expect(subject.name).to eq "Recommended minimum specific GNSS data" }
  end

  describe "time" do
    # 2014/01/01 0:00:00
    before{ Timecop.freeze Time.zone.at(TIMECOP_2014_01_01__0_00_00) }
    after{ Timecop.return }

    it{ expect(subject.time).to eq Time.zone.parse("2014/01/01 07:53:33") }
    it{ expect(subject.time.zone).to eq "UTC" }
  end

  describe "status" do
    it{ expect(subject.status).to eq :valid }
  end

  describe "latitude" do
    it{ expect(subject.latitude).to eq 35.65858 }
  end

  describe "longitude" do
    it{ expect(subject.longitude).to eq 139.74543299999996 }
  end

  describe "knot_per_hour" do
    it{ expect(subject.knot_per_hour).to eq 32.84}
  end

  describe "km_per_hour" do
    it{ expect(subject.km_per_hour).to eq(32.84 * 1.85200) }
  end

  describe "heading" do
    it{ expect(subject.heading).to eq 151.55 }
  end

  describe "date" do
    it{ expect(subject.date).to eq Date.parse("2014/12/17") }
  end

  describe "magnetic_variation" do
    it{ expect(subject.magnetic_variation).to eq nil }
  end

  describe "magnetic_variation_direction" do
    it{ expect(subject.magnetic_variation_direction).to eq nil }
  end

  describe "mode" do
    it{ expect(subject.mode).to eq :autonomous }
  end


end