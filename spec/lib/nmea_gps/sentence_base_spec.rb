require 'spec_helper'
require 'nmea_gps/sentence_base'

describe Nmea::Gps::SentenceBase do
  let(:raw_sentence_line){ "" }
  subject{ Nmea::Gps::SentenceBase.new raw_sentence_line }

  describe "initialize" do
    let(:raw_sentence_line){ "raw_sentence_line" }
    it{ expect(subject.raw_sentence_line).to eq raw_sentence_line }
  end

  describe "name" do
    it{ expect{ subject.name }.to raise_error }
  end

  describe "raw_data" do
    let(:raw_sentence_line){ "$GPNAME,#{(0..9).to_a.join(",")}*sum" }

    it{ expect(subject.raw_data.first).to eq "0" }
    it{ expect(subject.raw_data.last).to eq "9" }
  end


end
