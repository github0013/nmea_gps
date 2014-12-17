require 'spec_helper'
require 'nmea_gps/sentences/vtg'

describe Nmea::Gps::Vtg do
  let(:line){ "$GPVTG,93.98,T,,M,32.84,N,60.85,K,D*05" }
  subject{ Nmea::Gps::Vtg.new line }

  describe "name" do
    it{ expect(subject.name).to eq "Course over ground and ground speed" }
  end

  describe "true_course" do
    it{ expect(subject.true_course).to eq 93.98 }
  end

  describe "magnetic_course" do
    it{ expect(subject.magnetic_course).to eq nil }
  end

  describe "knot_per_hour" do
    it{ expect(subject.knot_per_hour).to eq 32.84 }
  end

  describe "km_per_hour" do
    it{ expect(subject.km_per_hour).to eq 60.85 }
  end

end