# frozen_string_literal: true

module QrCodeHelper
  def qr_code_as_svg(uri)
    RQRCode::QRCode.new(uri).as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 3
    ).html_safe
  end
end
