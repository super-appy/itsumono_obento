class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.line_registerd = 0

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'ユーザーを登録しました'
      redirect_to root_path
    else
      flash.now[:alert] = 'ユーザーの登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avator)
    # binding.pry
  end
end
