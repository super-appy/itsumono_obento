class LunchboxLogsController < ApplicationController
  before_action :set_select_lists, only: %i[new]

  def new
    @lunchbox_log = LunchboxLog.new
  end

  def create
    @lunchbox_log = current_user.lunchbox_logs.build(lunchbox_log_params)
    if @lunchbox_log.save
      redirect_to root_path, success: '成功したよ'
    else
      flash.now[:error] = '失敗したよ'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def lunchbox_log_params
    params.require(:lunchbox_log).permit(:cooked_date, :cooked_recipe_ids, :original_menu, :comment, :published_status)
  end

  def set_select_lists
    @cooked_recipes = current_user.bookmarked_recipes.where(status: :cooked).map { |bookmarked_recipe|
        [bookmarked_recipe.recipe.title, bookmarked_recipe.recipe_id]
      }
  end

end