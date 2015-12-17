class ApplicationController < ActionController::Base

  # FIXME_SG first authorize the user and then do set_i18n_locale_from_params
  # => also protect from forgery should be first line.
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
      # FIXME_SG: store User in instance variable say @user so that it is accessable in whole request cycle.
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
      # FIXME_SG: check presence of @user
      # FIXME_SG: write it like this
      # => return true unless @user and remove the outer if condition.
      if session[:user_id]
        # FIXME_SG: why are we using !!?
        if !!(session[:expire_time] and session[:expire_time] < Time.now)
          # FIXME_SG: use session.delete
          # => also check if we can use reset_session
          session[:user_id] = nil
          session[:expire_time] = nil
          redirect_to login_url, notice: "Session Expired"
        else
          # FIXME_SG: 30 must be a constant.
          session[:expire_time] = 30.minutes.since
        end
      end
    end

    # FIXME_SG: naming
    def check_browser
      # FIXME_SG: why don't use if condition1 && condition2
      if request.env['HTTP_USER_AGENT'].downcase.match(/firefox/i).present?
        # FIXME_SG: use controller_name instead
        if params[:controller] != "store"
          # FIXME_SG: use this syntax redirect_to login_url, notice: "Session Expired"
          flash[:notice] = "No Route Found"
          redirect_to store_url
        end
      end
    end

    def set_i18n_locale_from_params
      # FIXME_SG: write it like this
      # => return true unless params[:locale] and remove the outer if condition.
      if params[:locale]
        # FIXME_SG: use I18n.available_locales.include?(params[:locale].to_sym)
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          # FIXME_SG: use in single line to set flash message.
          # FIXME_SG: spacing
          flash.now[:notice] =
            "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end

    # FIXME_SG: remove if not using
    def default_url_options
      { locale: I18n.locale }
    end
end
