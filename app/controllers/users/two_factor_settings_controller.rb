class Users::TwoFactorSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :generate_two_factor_secret_if_missing!, only: :edit

  def edit
  end

  def update
    if current_user.validate_and_consume_otp!(two_factor_settings_params[:code])
      current_user.update(otp_required_for_login: true)
      flash[:notice] = 'Enabled two factor success'
      redirect_to edit_user_registration_path
    else
      flash.now[:alert] = 'Incorrect code'
      render :edit
    end
  end

  def destroy
    current_user.update!(
      otp_required_for_login: false,
      encrypted_otp_secret: nil,
      encrypted_otp_secret_iv: nil,
      encrypted_otp_secret_salt: nil,
    )
    flash[:notice] = '2FA has been disabled'
    redirect_to edit_user_registration_path
  end

  private

  def generate_two_factor_secret_if_missing!
    return if current_user.otp_secret.present?

    # https://github.com/tinfoil/devise-two-factor#enabling-two-factor-authentication
    current_user.update!(otp_secret: User.generate_otp_secret)
  end

  def two_factor_settings_params
    params.require(:two_factor_settings).permit(:code, :password)
  end
end
