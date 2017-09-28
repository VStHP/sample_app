class PasswordResetsController < ApplicationController
  before_action :gets_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "controllers.password_reset.flash_info_create"
      redirect_to :root
    else
      flash[:danger] = t "controllers.password_reset.flash_danger_create"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("controllers.password_reset.error_pw"))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "controllers.password_reset.flash_success_update"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "controllers.password_reset.flash_danger_check_expiration"
    redirect_to new_password_reset_url
  end

  def gets_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to :root
  end
end
