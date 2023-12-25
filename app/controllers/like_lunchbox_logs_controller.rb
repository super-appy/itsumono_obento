class LikeLunchboxLogsController < ApplicationController
  def create
    lunchbox_log = LunchboxLog.find(params[:lunchbox_log_id])
    current_user.like(lunchbox_log)
    redirect_to lunchbox_logs_path, success: 'お気に入りできたよ'
  end

  def destroy
    lunchbox_log = current_user.like_lunchbox_logs.find(params[:id]).lunchbox_log
    current_user.unlike(lunchbox_log)
    redirect_to lunchbox_logs_path, success: 'お気に入り外したよ'
  end
end
