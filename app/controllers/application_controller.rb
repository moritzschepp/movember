class ApplicationController < ActionController::Base

  helper_method :current_user
  helper_method :admin?
  helper_method :app_config

  before_filter :auth
  around_filter :fake_over
  
  def current_user
    @current_user ||= User.where(email: session[:current_user_email]).first
  end

  def admin?
    current_user && current_user.admin?
  end

  def app_config
    MoVember.config
  end
  
  protected
  
    def auth
      if current_user
        unless authorized?
          flash[:error] = "You are not authorized to see this page"
          redirect_to login_url
        end
      else
        flash[:error] = "You need to be logged in in order to see this page"
        redirect_to login_url
      end
    end

    def authorized?
      admin?
    end
    
    def fake_over
      if params[:fake_over]
        App.fake_over!
        yield
        App.release_fake_over!
      else
        yield
      end
    end

end
