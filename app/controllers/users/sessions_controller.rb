# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if params[:user][:email].empty?
      redirect_to new_user_session_path, notice: 'You need to provide valid email'
    else
      super
    end
  end

  # DELETE /resource/sign_out
  def destroy
    reset_session
    redirect_to home_url, notice: 'Signed out!'
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[first_name last_name nickname avatar])
  end
end
