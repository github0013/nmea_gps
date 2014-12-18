# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nmea_gps/version'

Gem::Specification.new do |spec|
  spec.name          = "nmea_gps"
  spec.version       = NmeaGps::VERSION
  spec.authors       = ["ore"]
  spec.email         = ["orenoimac@gmail.com"]
  spec.summary       = %q{NMEA GPS logs to trigger a callback on each NMEA 0183 sentence.}
  spec.description   = %q{add your serialport object, and you'll get callbacks every time the serialport gets logs.}
  spec.homepage      = "https://github.com/github0013/nmea_gps"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "timecop"
  spec.add_dependency "serialport"
  spec.add_dependency "activesupport"
end
