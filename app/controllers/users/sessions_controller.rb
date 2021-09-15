# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include AuthenticateWithOtpTwoFactor

  prepend_before_action :authenticate_with_otp_two_factor, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
    # super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
end
