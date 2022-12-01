# frozen_string_literal: true

# qr_code for exporting the list
module Qrcode
  extend ActiveSupport::Concern

  def generate_qrcode(list)
    list.qr_code = RQRCode::QRCode.new(list_url(list)).as_svg(
      offset: 0,
      color: '000',
      module_size: 5,
      shape_rendering: 'geometricPrecision',
      standalone: true,
      use_path: true
    )
  end
end
