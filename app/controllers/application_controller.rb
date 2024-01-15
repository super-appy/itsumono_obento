class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :notice, :alert, :error

  private

  def not_authenticated
    redirect_to login_path, alert: "ログインしてください"
  end

end
