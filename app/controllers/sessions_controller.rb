class SessionsController < ApplicationController
  skip_before_action :logged_in_user

  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by email: user_params[:email]
    if user && user.authenticate(user_params[:password])
      login user
      flash[:success] = t :login_success
      redirect_to root_path
    else
      flash[:danger] = t :login_false
      render :new
    end
  end

  def destroy
    logout current_user
    redirect_to home_path
  end

  private
  def user_params
    params.require(:session).permit :email, :password
  end
end
