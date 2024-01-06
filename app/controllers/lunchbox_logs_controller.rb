class LunchboxLogsController < ApplicationController
  before_action :set_select_lists, only: %i[new edit]

  def index
    @lunchbox_logs = LunchboxLog.all
  end

  def show
    @lunchbox_log = current_user.lunchbox_logs.find(params[:id])
    @previous_log = current_user.lunchbox_logs.where('cooked_date < ?', @lunchbox_log.cooked_date).order(cooked_date: :desc).first
    @next_log = current_user.lunchbox_logs.where('cooked_date > ?', @lunchbox_log.cooked_date).order(cooked_date: :asc).first
    @recipe = Recipe.find_by(id: @lunchbox_log.cooked_recipe_ids)
  end

  def new
    @lunchbox_log = LunchboxLog.new(cooked_date: Date.today)
  end

  def create
    @lunchbox_log = current_user.lunchbox_logs.build(lunchbox_log_params)
    if @lunchbox_log.save
      redirect_to lunchbox_logs_path, success: '成功したよ'
    else
      flash.now[:error] = '失敗したよ'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @lunchbox_log = current_user.lunchbox_logs.find(params[:id])
  end

  def update
    @lunchbox_log = current_user.lunchbox_logs.find(params[:id])
    if @lunchbox_log.update(lunchbox_log_params)
      redirect_to lunchbox_logs_path, success: '更新完了'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    lunchbox_log = current_user.lunchbox_logs.find(params[:id])
    lunchbox_log.destroy!
    redirect_to lunchbox_logs_path, status: :see_other
  end

  private

  def lunchbox_log_params
    params.require(:lunchbox_log).permit(:cooked_date, :cooked_recipe_ids, :original_menu, :comment, :published_status, :image)
  end

  def set_select_lists
    @cooked_recipes = current_user.bookmarked_recipes.where(status: :cooked).map { |bookmarked_recipe|
        [bookmarked_recipe.recipe.title, bookmarked_recipe.recipe_id]
      }
  end

end