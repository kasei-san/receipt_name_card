require "rubygems"
gem 'serialport','>=1.0.4'
require "serialport"
require "./bmp.rb"

class Recipt
  attr_reader :serialport

  def initialize(path)
    @serialport = SerialPort.new(path, 19200)
    @serialport.read_timeout = 1000
    @serialport.write "\e@" # ESC @ : Reset
    control_paramer(10, 255, 255)
  end

  def control_paramer(max_printing_dots, heating_time, heating_interval)
    @serialport.write "\e7#{max_printing_dots.chr}#{heating_time.chr}#{heating_interval.chr}"
  end

  def text_write(str)
    @serialport.write(str)
  end

  def image_write(path)
    bmp = Bmp.new(path)

    buffer  = "              # {0x12.chr}v" # DC2 v : Print LSB Bitmap
    buffer += bmp.height.chr # nL
    buffer += 0.chr          # nH
    buffer += bmp.image.map{|line| [line].pack("b*")}.join
    serialport.write(buffer)
  end

  def close
    serialport.close
  end
end

r = Recipt.new('/dev/tty.usbserial-FTGD4019')

r.text_write("--------------------------------\n")
r.image_write("./name.bmp")
r.text_write("--------------------------------\n")
r.text_write("\n")
r.text_write("Web engineer(Ruby on Rails)\n")
r.text_write("Maker\n")
r.text_write("Ninja Heads!\n")
r.text_write("\n")
r.text_write("twitter  : @kasei_san\n")
r.text_write("facebook : facebook.com/kaseisan\n")
r.text_write("Qiita    : qiita.com/kasei-san\n")

r.text_write("\n\n\n\n")

r.close
