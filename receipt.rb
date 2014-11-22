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

  HEIGHT = 50
  def image_write(path)
    bmp = Bmp.new(path)

    serialport.write("#{0x12.chr}v") # DC2 v : Print LSB Bitmap

    serialport.write(100.chr)  # nL
    serialport.write(0x00.chr) # nH
    bmp.image.each_with_index do |line, cnt|
      serialport.write([line].pack("b*"))
    end

    # Array.new(bmp.height / HEIGHT, HEIGHT).tap do |a|
      # a << bmp.height%HEIGHT if bmp.height%HEIGHT != 0
    # end.each_with_index do |height, cnt|
      # serialport.write("#{0x12.chr}v") # DC2 v : Print LSB Bitmap
      # serialport.write(height.chr)     # nL
      # # TODO : bmp.width  が 384px(MAX) 以外の場合を考慮していない
      # serialport.write(0.chr)       # nH

      # bmp.image[cnt*HEIGHT, height].each do |line|
        # serialport.write([line].pack("b*"))
      # end
    # end

   # Array.new(bmp.height / 50, 50).tap do |a|
     # a << bmp.height%50 if bmp.height%50 != 0
   # end.each_with_index do |height, cnt|
      # serialport.write("#{0x12.chr}v") # DC2 v : Print LSB Bitmap
      # serialport.write(height.chr)     # nL
      # # TODO : bmp.width  が 384px(MAX) 以外の場合を考慮していない
      # serialport.write(0x00.chr)       # nH

      # bmp.image[cnt*50, height].each do |line|
        # p line
        # [line].pack("b*").split(//).each do |chr|
          # serialport.write(chr)
        # end
      # end
   # end
   serialport.write("\n\n")
  end

  def close
    serialport.close
  end
end

r = Recipt.new('/dev/tty.usbserial-FTGD4019')
# r.text_write("abc\n")
r.image_write("./name2.bmp")
r.close
