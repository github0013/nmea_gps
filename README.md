## Why another NMEA gem?
I was looking for a NMEA gem, but none of them I could find were written in the ruby-way.  
I wanted to get GPS data pushed when it gets updated, so I created one.

## Installation

Add this line to your application's Gemfile:

    gem 'nmea_gps'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nmea_gps

## Usage

```ruby

# set your zone if you want to get time in you local time zone. 
# otherwise it will be UTC
Nmea::Config.time_zone = "Tokyo"

# create a serialport to your GPS receiver
# you should know how to open a connection between your GPS device
# mine runs on `9600 baudrate`, `8bit`, `1stop bit`, `none parity`
serialport = SerialPort.new("/dev/cu.your_whatever_device", 9600, 8, 1, SerialPort::NONE)

# you should know about your GPS receiver's update Hz(how often it will update logs 10Hz = 10 times per sec.)
# if you don't know leave it blank.  It will at least update every sec.
gps = Nmea::Gps.new serialport update_hz: 10

# this will be called automatically!!
gps.rmc do |rmc|
  # you will get a sentence object as a parameter
  # for gsv callback, it will be an array containing multiple gsv objects [gsv, gsv, gsv]
  p rmc.raw_sentence_line
  p rmc.time
  p rmc.latitude
  p rmc.longitude
  p rmc.heading
  p rmc.date
end
# sentences > https://github.com/github0013/nmea_gps/tree/master/lib/nmea_gps/sentences
# you have a callback on each sentence such as gga, gll ..., 

# built-in error callback (catch errors in the internal thread)
gps.error do |exception|
  p exception.message
  puts exception.backtrace.join "\n"
end

# start the tracking
gps.track!

# you can also have
# gps.gga do |gga|
#   ..
# end
# gps.gll do |gll|
#   ..
# end
# gps.gsa do |gsa|
#   ..
# end
# gps.vtg do |vtg|
#   ..
# end
# gps.zda do |zda|
#   ..
# end
# 
# this one gets multiple Gsv objects
# gps.gsv do |gsvs|
#   p gsvs.count
#   ..
# end

# do your other works
# ..
# ..
# ..

# when you want to stop callbacks, you can call this
# gps.stop!
# then close the connection
# serialport.close
```

## sentences
[click here](https://github.com/github0013/nmea_gps/tree/master/lib/nmea_gps/sentences) for details

| sentence | callback | parameter to be passed |
|:----|:----|:---------------|
| GGA | gga | Nmea::Gps::Gga |
| GLL | gll | Nmea::Gps::Gll |
| GSA | gsa | Nmea::Gps::Gsa |
| GSV | gsv | [Nmea::Gps::Gsv, Nmea::Gps::Gsv, ...] |
| RMC | rmc | Nmea::Gps::Rmc |
| VTG | vtg | Nmea::Gps::Vtg |
| ZDA | zda | Nmea::Gps::Zda |

## Contributing

1. Fork it ( https://github.com/[my-github-username]/nmea_gps/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
