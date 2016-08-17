class RelationshipsController < ApplicationController
  before_action :load_user
  def create
    current_user.follow @user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private
  def load_user
    @user = User.find_by id: params[:followed_id]
    if @user.nil?
      flash[:danger] = t :not_found_user
      redirect_to current_user
    end
  end
end
