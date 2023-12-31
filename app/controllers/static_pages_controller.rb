class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: :top

  def top; end

  def mypage
    # @lunchbox_logs = LunchboxLog.where(cooked_date: start_time.beginning_of_week..start_time.end_of_weekh)
    @lunchbox_logs = current_user.lunchbox_logs
    @want_to_cook_recipes = current_user.want_to_cook_recipes.take(3)
    @cooked_recipes = current_user.cooked_recipes.take(3)
    @posted_recipes = current_user.recipes.order(created_at: :desc)
  end
end
