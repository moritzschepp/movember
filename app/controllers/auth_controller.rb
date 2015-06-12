class AuthController < ApplicationController

  skip_before_filter :auth

  def login_form
    
  end

  def authenticate
    @user = User.login params[:credentials]

    if @user
      flash[:notice] = "Login successful"
      session[:current_user_email] = @user.email
      redirect_to (params[:redirect_to] || root_url)
    else
      flash[:error] = "Credentials incorrect, please try again"
      render action: "login_form"
    end
  end

  def logout
    reset_session
    redirect_to root_url
  end

end