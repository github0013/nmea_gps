require 'spec_helper'
require 'nmea_gps/sentences/gll'

describe Nmea::Gps::Gll do
  let(:line){ "$GPGLL,3539.51480,N,13944.72598,E,075247.000,A,A*5D" }
  subject{ Nmea::Gps::Gll.new line }

  describe "name" do
    it{ expect(subject.name).to eq "Geographic position—latitude/longitude" }
  end

  describe "latitude" do
    it{ expect(subject.latitude).to eq 35.65858 }
  end

  describe "longitude" do
    it{ expect(subject.longitude).to eq 139.74543299999996 }
  end

  describe "time" do
    # 2014/01/01 0:00:00
    before{ Timecop.freeze Time.zone.at(TIMECOP_2014_01_01__0_00_00) }
    after{ Timecop.return }

    it{ expect(subject.time).to eq Time.zone.parse("2014/01/01 07:52:47") }
    it{ expect(subject.time.zone).to eq "UTC" }
  end

  describe "status" do
    it{ expect(subject.status).to eq :valid }
  end

  describe "mode" do
    it{ expect(subject.mode).to eq :autonomous }
  end

end
