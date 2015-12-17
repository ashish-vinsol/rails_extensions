class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  # ...
  before_action :authorize
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_expire

  before_action :check_browser

  protected

    def authorize
      if request.format == Mime::HTML
        unless User.find_by(id: session[:user_id])
          redirect_to login_url, notice: "Please log in"
        end
      else
        authenticate_or_request_with_http_basic do |username, password|
          user = User.find_by(name: username)
          user && user.authenticate(password)
        end
      end
    end

    def check_expire
      if session[:user_id]
        if !!(session[:expire_time] and session[:expire_time] < Time.now)
          session[:user_id] = nil
          session[:expire_time] = nil
          redirect_to login_url, notice: "Session Expired"
        else
          session[:expire_time] = 30.minutes.since
        end
      end
    end

    def check_browser
      if request.env['HTTP_USER_AGENT'].downcase.match(/firefox/i).present?
        if params[:controller] != "store"
          flash[:notice] = "No Route Found"
          redirect_to store_url
        end
      end
    end

    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          flash.now[:notice] =
            "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end

    def default_url_options
      { locale: I18n.locale }
    end
end
