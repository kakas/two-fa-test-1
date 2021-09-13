module Users::TwoFactorSettingsHelper
  def qr_code_as_svg(uri)
    RQRCode::QRCode.new(uri).as_svg(module_size: 4, use_path: true).html_safe
  end
end
