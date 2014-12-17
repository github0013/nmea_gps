require 'spec_helper'
require 'nmea_gps/gps'

describe Nmea::DddFormatable do
  class Target
    include Nmea::DddFormatable
  end

  subject{ Target.new }

  describe "dmm_to_ddd" do
    let(:dmm){ 3539.51480 }
    let(:direction){ "N" }

    it{ expect(subject.send :dmm_to_ddd, dmm, direction).to eq 35.65858 }
  end

end
