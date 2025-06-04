# app/services/cheese_qr_code_generator.rb
require "rqrcode"
require "chunky_png"

class CheeseQrCodeGenerator
  def initialize(data)
    @data = data
  end

  def render_png
    qrcode = RQRCode::QRCode.new(@data)

    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      size: 300,
      module_px_size: 6,
      file: nil
    )

    png.to_s
  end
end
