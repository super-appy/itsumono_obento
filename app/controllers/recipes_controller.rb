class RecipesController < ApplicationController
  include SelectListable
  before_action :set_select_lists, only: :new
  skip_before_action :require_login, only: [:index, :show]

  def index
    @tags = Tag.all
    @q = Recipe.ransack(params[:q])
    if logged_in?
      # 検索のパラメーターをjsonで保存
      if params[:q].present? && !all_blank(params[:q]) && current_user
        current_user.user_search_logs.create!(search_params: params[:q].to_json)
      end
      # 3つ以上になったら、古いものから削除する
      if current_user.user_search_logs.size > 3
        oldest_log = current_user.user_search_logs.order(:created_at).first
        oldest_log.destroy
      end
    end
    @recipes = @q.result.includes(:tags).sorted_by_creation.distinct.page(params[:page])
  end

  def posted
    @posted_recipes = current_user.recipes.where(api_resp: nil).page(params[:page])
  end

  def new
    @recipe = Recipe.build_with_ingredients_and_steps
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    @recipe.tag_ids = recipe_params[:tag_ids].reject(&:blank?)
    @recipe.taste_tag_time = @recipe.make_taste_tag_time(recipe_params[:tag_ids])

    if @recipe.save
      session[:from_action] = 'create'
      redirect_to recipe_path(@recipe), success: "#{@recipe.title}のレシピを投稿しました！ありがとうございます！"
    else
      set_select_lists
      (3 - @recipe.recipe_ingredients.size).times { @recipe.recipe_ingredients.build }
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @from_action = session[:from_action]
    session.delete(:from_action)
    @tags = @recipe.tags
    @recipe_ingredients = RecipeIngredient.where(recipe_id: params[:recipe_id])
    @recipe_steps = RecipeStep.where(recipe_id: params[:recipe_id])
  end

  def edit
    @recipe = current_user.recipes.find(params[:id])
    session[:from_action] = 'create'
    @tags = set_select_lists
    @selected_tags = @recipe.tags.group_by(&:category).transform_values do |tags|
      tags.map(&:id)
    end
  end

  def update
    @recipe = current_user.recipes.find(params[:id])
    @recipe.assign_attributes(recipe_params)
    @recipe.taste_tag_time = @recipe.make_taste_tag_time(recipe_params[:tag_ids])
    if @recipe.save
      redirect_to recipe_path(@recipe), success: "#{@recipe.title}のレシピを編集しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = current_user.recipes.find(params[:id])
    recipe.destroy!
    redirect_to recipes_path, status: :see_other
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :time_required, :taste, tag_ids:[],
      recipe_ingredients_attributes: [:id, :name, :quantity, :_destroy],
      recipe_steps_attributes: [:id, :number, :description, :_destroy])
  end

  def all_blank(params)
    params.to_unsafe_h.all? { |_, v| v.blank? }
  end

end
