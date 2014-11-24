require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'
require_relative 'bmp.rb'

class Recipt
  attr_reader :serialport

  def initialize(path, &proc)
    @serialport = SerialPort.new(path, 19200)
    serialport.read_timeout = 1000
    serialport.write "\e@" # ESC @ : Reset
    control_paramer
    instance_eval(&proc)
    serialport.close
  end

  # プリンタの設定
  # * 画像が薄い時は、max_printing_dots の値を下げると良い
  #
  def control_paramer(max_printing_dots=10, heating_time=80, heating_interval=2)
    serialport.write "\e7#{max_printing_dots.chr}#{heating_time.chr}#{heating_interval.chr}"
  end

  # テキストの描画
  # * 最後に改行を入れる必要あり
  #
  def text_write(str)
    serialport.write(str)
  end

  # 画像の描画
  # * 0S/2 フォーマットの 2値ビットマップで、幅384px のみ対応
  #
  def image_write(path)
    bmp = Bmp.new(path)

    buffer  = "#{0x12.chr}v" # DC2 v : Print LSB Bitmap
    # TODO : 高さが0xFF以上の画像未対応
    buffer += bmp.height.chr # nL
    # TODO : 幅が最大値以外の画像未対応
    buffer += 0.chr          # nH
    buffer += bmp.image.map{|line| [line].pack("b*")}.join
    serialport.write(buffer)
  end

  def close
    serialport.close
  end
end
