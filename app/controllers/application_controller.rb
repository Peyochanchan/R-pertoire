class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit::Authorization
  around_action :switch_locale

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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
    { host: ENV.fetch('DOMAIN') || 'localhost:3000' }
  end

  def set_locale
    I18n.locale = params.fetch(:locale, I18n.locale).to_sym
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    record = exception.policy.record.class.to_s
    if ((exception.query == 'create?') && (policy_name == 'song_policy')) || ((exception.query == 'create?') && (policy_name == 'list_policy'))
      flash[:alert] = "I'm sorry, This is a Demo Version. You can not create a #{record} because... Google Cloud Translation API is not free"
    else
      flash[:alert] = 'You\'re not allowed to perform this action.'
    end
    redirect_to user_root_path
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
