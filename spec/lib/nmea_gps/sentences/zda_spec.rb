require 'spec_helper'
require 'nmea_gps/sentences/zda'

describe Nmea::Gps::Zda do
  let(:line){ "$GPZDA,075936.000,17,12,2014,,*5A" }
  subject{ Nmea::Gps::Zda.new line }

  describe "name" do
    it{ expect(subject.name).to eq "Date and Time" }
  end

  describe "time" do
    # 2014/01/01 0:00:00
    before{ Timecop.freeze Time.zone.at(TIMECOP_2014_01_01__0_00_00) }
    after{ Timecop.return }

    it{ expect(subject.time).to eq Time.zone.parse("2014/01/01 07:59:36") }
    it{ expect(subject.time.zone).to eq "UTC" }
  end

  describe "date" do
    it{ expect(subject.date).to eq Date.parse("2014/12/17") }
  end

  describe "local_zone_hours" do
    it{ expect(subject.local_zone_hours).to eq nil }
  end

  describe "local_zone_minutes" do
    it{ expect(subject.local_zone_minutes).to eq nil }
  end
end