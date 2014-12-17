require 'spec_helper'
require 'nmea_gps/sentences/gsv'

describe Nmea::Gps::Gsv do
  let(:line){ "$GPGSV,3,1,11,24,70,198,52,15,63,016,32,50,47,156,39,21,44,270,38*79" }
  subject{ Nmea::Gps::Gsv.new line }

  describe "name" do
    it{ expect(subject.name).to eq "GNSS satellites in view" }
  end

  describe "number_of_message" do
    it{ expect(subject.number_of_message).to eq 3 }
  end

  describe "message_number" do
    it{ expect(subject.message_number).to eq 1 }
  end

  describe "number_of_satellites_in_view" do
    it{ expect(subject.number_of_satellites_in_view).to eq 11 }
  end

  describe "satellites" do
    it{ expect(subject.satellites.count).to eq 4 }

    context "first satellite" do
      let(:satellite){ subject.satellites.first }
      it{ expect(satellite.id).to eq 24 }
      it{ expect(satellite.elevation).to eq 70 }
      it{ expect(satellite.azinmuth).to eq 198 }
      it{ expect(satellite.signal_to_noise_ratio).to eq 52 }
    end
  end

end