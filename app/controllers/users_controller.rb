class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update show)
  before_action :correct_user, only: %i(edit update show)
  before_action :admin_user, only: %i(destroy)
  before_action :load_user, except: %i(index new create)
  def index
    @users = User.paginate(page: params[:page])
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = t "controllers.users.flash_success_create"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controllers.users.flash_success_update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.users.flash_success_destroy"
    else
      flash[:danger] = t "controllers.users.flash_danger_destroy"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controllers.users.flash_danger_not_login"
    redirect_to login_url
  end

  def correct_user
    load_user
    redirect_to :root unless current_user? @user
  end

  def admin_user
    redirect_to :root unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controllers.users.flash_danger_not_found"
    redirect_to :root
  end
end
