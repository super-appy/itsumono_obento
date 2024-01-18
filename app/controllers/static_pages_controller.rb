class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top privacy_policy terms_of_use]

  def top; end

  def mypage
    @lunchbox_logs = current_user.lunchbox_logs
    @want_to_cook_recipes = current_user.want_to_cook_recipes.take(3)
    @cooked_recipes = current_user.cooked_recipes.take(3)
    @posted_recipes = current_user.recipes.order(created_at: :desc).take(3)
  end

  def privacy_policy; end

  def terms_of_use; end
end
