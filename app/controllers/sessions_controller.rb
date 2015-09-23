class SessionsController < ApplicationController
  before_filter :save_login_state, :only => [:login, :login_attempt]

  def login
  end

  def login_attempt
    authorized_user = User.authenticate(params[:username],params[:password])
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "Welcome #{authorized_user.display_name}!"
      redirect_to reports_url, :action => 'get'
    else
      flash[:notice] = "Invalid Username or Password"
      render "login"
    end
  end


  def logout
    session[:user_id] = nil
    redirect_to :action => 'login'
  end
end
