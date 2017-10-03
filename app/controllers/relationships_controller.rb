class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find params[:followed_id]
    unless @user
      flash[:danger] = t "controllers.relationships.flash_danger_find"
      redirect_to :root
    end
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    unless @user
      flash[:danger] = t "controllers.relationships.flash_danger_find"
      redirect_to :root
    end
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end