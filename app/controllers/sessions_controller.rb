class SessionsController < ApplicationController
  def new; end

  def remember_me_load user
    params[:session][:remember_me] == Settings.session.value_checkbox ? remember(user) : forget(user)
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember_me_load user
      redirect_back_or user
    else
      flash.now[:danger] = I18n.t "sessions.new.flash_danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
