class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t :sign_up_successful
      redirect_to root_url
    else
      render :new
    end
  end
  def show
    @user = User.find_by id: params[:id]
  end

  def index
    @users = User.paginate page: params[:page]
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :phone, :address,
      :sex, :avatar, :password, :password_confirmation
  end
end
