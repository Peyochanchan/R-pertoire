# frozen_string_literal: true

require 'open-uri'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    callback('google_oauth2')
  end

  def facebook
    callback('facebook')
  end

  def github
    callback('github')
  end

  def failure
    redirect_to home_path, notice: 'Seems you weren\'t authorized after all, we\'re sorry for this inconvenience !'
  end

  private

  def callback(provider)
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)
    @user.avatar.attach(io: URI.open(auth.info.image), filename: 'photo')
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize.to_s) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = auth.except('extra')
      puts @user.errors
      redirect_to new_user_registration_url
    end
  end
end

