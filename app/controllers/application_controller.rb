class ApplicationController < ActionController::Base
  before_action :authenticate_user!, if: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit::Authorization

  around_action :switch_locale

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name nickname avatar password password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name nickname avatar password password_confirmation current_password])
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
    { host: ENV.fetch['DOMAIN'] || 'localhost:3000' }
  end

  def set_locale
    I18n.locale = params.fetch(:locale, I18n.locale).to_sym
  end

  private

  # Uncomment when you *really understand* Pundit!
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
