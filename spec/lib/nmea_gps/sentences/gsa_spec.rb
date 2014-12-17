require 'spec_helper'
require 'nmea_gps/sentences/gsa'

describe Nmea::Gps::Gsa do
  let(:line){ "$GPGSA,A,3,24,26,05,13,21,12,15,18,,,,,1.29,0.97,0.86*00" }
  subject{ Nmea::Gps::Gsa.new line }

  describe "name" do
    it{ expect(subject.name).to eq "GNSS DOP and active satellites" }
  end

  describe "mode_selection" do 
    it{ expect(subject.mode_selection).to eq :automatic }
  end

  describe "mode" do
    it{ expect(subject.mode).to eq :fix_3D }
  end

  describe "ids_of_svs_used_in_position_fix" do
    let(:at){ :all }
    context "all" do
      it{ expect(subject.ids_of_svs_used_in_position_fix.count).to eq 12 }
    end

    context "a position" do
      it{ expect(subject.ids_of_svs_used_in_position_fix(3)).to eq 5 }
      it{ expect(subject.ids_of_svs_used_in_position_fix(12)).to eq nil }
    end
  end

  describe "position_dilution_of_precision" do
    it{ expect(subject.position_dilution_of_precision).to eq 1.29 }
  end

  describe "horizontal_dilution_of_precision" do
    it{ expect(subject.horizontal_dilution_of_precision).to eq 0.97 }
  end

  describe "vertical_dilution_of_precision" do
    it{ expect(subject.vertical_dilution_of_precision).to eq 0.86 }
  end

end