require 'spec_helper'
require 'nmea_gps/gps'

describe Nmea::UtcTimeable do
  class Target
    include Nmea::UtcTimeable
  end

  subject{ Target.new }

  describe "hhmmss_to_local_time" do
    let(:text){ "101112.000" }

    # 2014/01/01 0:00:00
    before{ Timecop.freeze Time.zone.at(TIMECOP_2014_01_01__0_00_00) }
    after{ Timecop.return }

    context "when Nmea::Config.time_zone is nil" do
      let(:time){ subject.send :hhmmss_to_local_time, text }
      it{ expect(time).to eq Time.zone.parse("2014/01/01 10:11:12") }
      it{ expect(time.zone).to eq "UTC" }

      context "when 'Tokyo'" do
        before{ Nmea::Config.time_zone = "Tokyo" }
        it{ expect(time).to eq Time.zone.parse("2014/01/01 10:11:12").in_time_zone "Tokyo" }
        it{ expect(time.zone).to eq "JST" }
      end
    end

  end

end
