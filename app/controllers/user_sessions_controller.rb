class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to root_path, success: 'Login successful'
    else
      flash.now[:alert] = 'Login failed'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'Logged out!'
  end
end