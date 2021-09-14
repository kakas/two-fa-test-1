# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user = User.find_for_database_authentication(email: sign_in_params[:email])
    if user.nil? || !user.valid_password?(sign_in_params[:password])
      flash[:alert] = I18n.t('devise.failure.invalid', authentication_keys: 'Email')
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      return render :new
    end

    if user.otp_required_for_login && !user.validate_and_consume_otp!(sign_in_params[:otp_attempt])
      flash[:alert] = 'Invalid code'
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      return render :new
    end

    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, user)
    yield user if block_given?
    respond_with user, location: after_sign_in_path_for(user)
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
end
