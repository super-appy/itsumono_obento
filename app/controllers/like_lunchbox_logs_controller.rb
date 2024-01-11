class LikeLunchboxLogsController < ApplicationController
  def create
    @lunchbox_log = LunchboxLog.find(params[:lunchbox_log_id])
    current_user.like(@lunchbox_log)
  end

  def destroy
    @lunchbox_log = current_user.like_lunchbox_logs.find(params[:id]).lunchbox_log
    current_user.unlike(@lunchbox_log) if @lunchbox_log.present?
  end
end
