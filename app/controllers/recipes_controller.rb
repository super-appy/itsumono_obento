class RecipesController < ApplicationController
  before_action :set_select_lists, only: :new
  skip_before_action :require_login, only: [:index, :show]

  def index
    @tags = Tag.all
    @q = Recipe.ransack(params[:q])
    @recipes = @q.result.includes(:tags).sorted_by_creation.distinct
  end

  def posted
    @posted_recipes = current_user.recipes
  end

  def new
    @recipe = Recipe.build_with_ingredients_and_steps
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    @recipe.tag_ids = recipe_params[:tag_ids].reject(&:blank?)
    @recipe.taste_tag_time = @recipe.make_taste_tag_time(recipe_params[:tag_ids])

    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      set_select_lists
      (3 - @recipe.recipe_ingredients.size).times { @recipe.recipe_ingredients.build }
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @tags = @recipe.tags
    @recipe_ingredients = RecipeIngredient.where(recipe_id: params[:recipe_id])
    @recipe_steps = RecipeStep.where(recipe_id: params[:recipe_id])
  end

  def edit
    @recipe = current_user.recipes.find(params[:id])
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
      redirect_to recipe_path(@recipe), success: 'レシピ編集できた！'
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

  def set_select_lists
    @tags = Tag.all.group_by(&:category).transform_values do |tags|
      tags.map { |tag| [tag.name, tag.id] }
    end
  end

end
