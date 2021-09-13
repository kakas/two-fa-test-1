class User < ApplicationRecord
  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => ENV['TOTP_2FA_SECRET_KEY']

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :validatable

  # URI for OTP two-factor QR code
  def two_factor_qr_code_uri
    issuer = 'two-fa-test-1 App'
    label = "#{issuer}:#{email}"
    otp_provisioning_uri(label, issuer: issuer)
  end
end
