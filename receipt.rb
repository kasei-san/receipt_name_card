require "rubygems"
gem 'serialport','>=1.0.4'
require "serialport"
require "./bmp.rb"

class Recipt
  attr_reader :serialport

  def initialize(path, &proc)
    @serialport = SerialPort.new(path, 19200)
    @serialport.read_timeout = 1000
    @serialport.write "\e@" # ESC @ : Reset
    control_paramer
    instance_eval(&proc)
    @serialport.close
  end

  def control_paramer(max_printing_dots=10, heating_time=80, heating_interval=2)
    @serialport.write "\e7#{max_printing_dots.chr}#{heating_time.chr}#{heating_interval.chr}"
  end

  def text_write(str)
    @serialport.write(str)
  end

  def image_write(path)
    bmp = Bmp.new(path)

    buffer  = "#{0x12.chr}v" # DC2 v : Print LSB Bitmap
    buffer += bmp.height.chr # nL
    buffer += 0.chr          # nH
    buffer += bmp.image.map{|line| [line].pack("b*")}.join
    serialport.write(buffer)
  end

  def close
    serialport.close
  end
end

Recipt.new('/dev/tty.usbserial-FTGD4019') do
  control_paramer(5, 160, 4)
  text_write("--------------------------------\n")
  image_write("./name.bmp")
  text_write("--------------------------------\n")
  image_write("./qr.bmp")
  text_write("  How to make Cyber Sunglasses  \n")
  text_write("--------------------------------\n")
  text_write("\n")
  text_write("Web engineer(Ruby on Rails)\n")
  text_write("Maker\n")
  text_write("Ninja Heads!\n")
  text_write("\n")
  text_write("twitter  : @kasei_san\n")
  text_write("facebook : facebook.com/kaseisan\n")
  text_write("Qiita    : qiita.com/kasei-san\n")
  text_write("\n\n\n\n")
end
