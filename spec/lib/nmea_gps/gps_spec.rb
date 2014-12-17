require 'spec_helper'
require 'nmea_gps/gps'
require 'nmea_gps/sentences/gga'
require 'nmea_gps/sentences/gll'
require 'nmea_gps/sentences/gsa'
require 'nmea_gps/sentences/gsv'
require 'nmea_gps/sentences/rmc'
require 'nmea_gps/sentences/vtg'
require 'nmea_gps/sentences/zda'

describe Nmea::Gps do
  let(:serial_port){ double("serial_port") }
  let(:update_hz){ 1 }
  let(:gps){ Nmea::Gps.new serial_port, update_hz: update_hz }

  describe "hz" do
    subject{ gps.send :hz }
    it{ expect(subject).to eq 1 }

    context "10Hz" do 
      let(:update_hz){ 10 }
      it{ expect(subject).to eq 0.1 }
    end
  end

  describe "frequency" do
    before{ expect(gps).to receive(:sleep).with(hz).at_least 1 }
    
    let(:hz){ 1 / 1 }
    it{ gps.send :frequency }

    context "10Hz" do
      let(:update_hz){ 10 }
      let(:hz){ 1 / 10.0 }
      it{ gps.send :frequency }
    end
  end

  describe "dynamic sentence methods" do
    it{ expect(gps).to respond_to :gga }
    it{ expect(gps).to respond_to :gll }
    it{ expect(gps).to respond_to :gsa }
    it{ expect(gps).to respond_to :gsv }
    it{ expect(gps).to respond_to :rmc }
    it{ expect(gps).to respond_to :gga }
    it{ expect(gps).to respond_to :vtg }
    it{ expect(gps).to respond_to :zda }
  end

  describe "line_set" do
    before do
      allow(serial_port).to receive(:gets).and_return *lines.collect{|line| "#{line}\r\n" }
    end

    subject{ gps.send :line_set }

    context "single line" do
      let(:lines) do
        ["$GPGGA,075800.000,3357.7401,N,13112.3701,E,2,9,1.04,-3.6,M,27.5,M,0000,0000*74"]
      end
      it{ expect(subject.keys).to eq [:gga] }
    end

    context "multiple lines" do
      let(:lines) do
        [
          "$GPGLL,3539.51480,N,13944.72598,E,075247.000,A,A*5D",
          "$GPGSA,A,3,24,26,05,13,21,12,15,18,,,,,1.29,0.97,0.86*00",
          "$GPGSV,3,1,11,24,70,198,52,15,63,016,,50,47,156,38,21,44,270,39*78",
          "$GPGSV,3,2,11,18,40,314,30,26,27,058,46,05,19,124,42,12,09,159,35*73",
          "$GPGSV,3,3,11,13,07,067,35,28,07,041,15,22,05,309,28*42",
          "$GPRMC,075333.000,A,3539.51480,N,13944.72598,E,32.84,151.55,171214,,,A*68",
          "$GPVTG,93.98,T,,M,32.84,N,60.85,K,D*05",
          "$GPZDA,075936.000,17,12,2014,,*5A",
          "$GPGGA,075800.000,3357.7401,N,13112.3701,E,2,9,1.04,-3.6,M,27.5,M,0000,0000*74",
        ]
      end
      it{ expect(subject.keys.sort).to eq [:gga, :gll, :gsa, :gsv, :rmc, :vtg, :zda] }
      it do expect(subject).to eq({

        gga: ["$GPGGA,075800.000,3357.7401,N,13112.3701,E,2,9,1.04,-3.6,M,27.5,M,0000,0000*74"],
        gll: ["$GPGLL,3539.51480,N,13944.72598,E,075247.000,A,A*5D"],
        gsa: ["$GPGSA,A,3,24,26,05,13,21,12,15,18,,,,,1.29,0.97,0.86*00"],
        gsv: [
          "$GPGSV,3,1,11,24,70,198,52,15,63,016,,50,47,156,38,21,44,270,39*78",
          "$GPGSV,3,2,11,18,40,314,30,26,27,058,46,05,19,124,42,12,09,159,35*73",
          "$GPGSV,3,3,11,13,07,067,35,28,07,041,15,22,05,309,28*42",
        ],
        rmc: ["$GPRMC,075333.000,A,3539.51480,N,13944.72598,E,32.84,151.55,171214,,,A*68"],
        vtg: ["$GPVTG,93.98,T,,M,32.84,N,60.85,K,D*05"],
        zda: ["$GPZDA,075936.000,17,12,2014,,*5A"],
        })
      end
    end

  end

  describe "callback!" do
    before do
      allow(gps).to receive(:line_set).and_return(
        {
          gga: ["$GPGGA,075800.000,3357.7401,N,13112.3701,E,2,9,1.04,-3.6,M,27.5,M,0000,0000*74"],
          gsv: [
            "$GPGSV,3,1,11,24,70,198,52,15,63,016,,50,47,156,38,21,44,270,39*78",
            "$GPGSV,3,2,11,18,40,314,30,26,27,058,46,05,19,124,42,12,09,159,35*73",
            "$GPGSV,3,3,11,13,07,067,35,28,07,041,15,22,05,309,28*42",
          ],
        }
      )
    end

    it "single line callback" do 
      gps.gga do |gga|
        expect(gga.class).to eq Nmea::Gps::Gga
      end
      gps.send :callback!
    end

    it "multiple line callback" do
      gps.gsv do |gsvs|
        expect(gsvs.count).to eq 3
        expect(gsvs.first.class).to eq Nmea::Gps::Gsv
      end
      gps.send :callback!
    end
  end

  describe "kill!" do
    before do
      thread = double("thread")
      expect(thread).to receive(:kill).at_least(1)
      gps.instance_eval{ self.track_thread = thread }
    end

    it{ gps.stop! }
  end

end
