require 'spec_helper'
require 'nmea_gps/sentence_base'

describe Nmea::Gps::SentenceBase do
  let(:line){ "" }
  subject{ Nmea::Gps::SentenceBase.new line }

  describe "initialize" do
    let(:line){ "line" }
    it{ expect(subject.instance_eval{@line}).to eq line }
  end

  describe "name" do
    it{ expect{ subject.name }.to raise_error }
  end

  describe "raw_data" do
    let(:line){ "$GPNAME,#{(0..9).to_a.join(",")}*sum" }

    it{ expect(subject.raw_data.first).to eq "0" }
    it{ expect(subject.raw_data.last).to eq "9" }
  end


end
