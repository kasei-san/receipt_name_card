class Bmp
  attr_reader :bitmap_file_header,
              :bitmap_core_header,
              :color_pallettes,
              :image,
              :file

  def initialize(path)
    @path = path

    @file = File.open(path)
    @file.extend(BmpFile)

    load_BITMAPFILEHEADER
    load_BITMAPCOREHEADER
    load_color_palettes
    load_image

    @file.close
  end

  def width
    @bitmap_core_header[:bcWidth]
  end

  def height
    @bitmap_core_header[:bcHeight]
  end



  private

  def load_BITMAPFILEHEADER
    @bitmap_file_header = {
      :bfType      => file.read(2),
      :bfSize      => file.load_long,
      :bfReserved1 => file.load_short,
      :bfReserved2 => file.load_short,
      :bfOffBits   => file.load_long
    }
  end

  def load_BITMAPCOREHEADER
    @bitmap_core_header = {
      :bcSize     => file.load_long,
      :bcWidth    => file.load_short,
      :bcHeight   => file.load_short,
      :bcPlanes   => file.load_short,
      :bcBitCount => file.load_short,
    }
  end

  def load_color_palettes
    @color_pallettes = []
    1.upto(2 ** @bitmap_core_header[:bcBitCount]) do
      @color_pallettes << { :r => file.load_char, :g => file.load_char, :b => file.load_char }
    end
  end

  def load_image
    @image = []
    1.upto(height) do
      image.unshift(file.load_bitstring(width))
    end
  end

  module BmpFile
    def load_long
      self.read(4).unpack('I!').first
    end

    def load_short
      self.read(2).unpack('S!').first
    end

    def load_char
      self.read(1).unpack('C*').first
    end

    def load_bitstring(size)
      self.read(size/8).unpack('B*').first
    end
  end
end
