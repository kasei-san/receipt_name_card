require_relative 'receipt.rb'
Recipt.new('/dev/tty.usbserial-FTGD4019') do
  control_paramer(5, 80, 2)
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
