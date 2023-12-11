class RecipesController < ApplicationController
  before_action :set_select_lists, only: [:new]

  def index
    @recipes = Recipe.all
    
  end

  def new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.new
    @recipe.recipe_steps.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    @recipe.taste_tag_time = make_taste_tag_time(@recipe, @recipe.tag_ids)

    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      render :new
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_ingredients = RecipeIngredient.where(recipe_id: params[:recipe_id])
    @recipe_steps = RecipeStep.where(recipe_id: params[:recipe_id])
    @tags = @recipe.tags
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :time_required, :taste, tag_ids:[],
      recipe_ingredients_attributes: [:id, :name, :quantity],
      recipe_steps_attributes: [:id, :number, :description],
      )
  end

  def set_select_lists
    @tags = Tag.all.group_by(&:category).transform_values do |tags|
      tags.map { |tag| [tag.name, tag.id] }
    end
  end

  def get_response
  end

  def make_taste_tag_time(recipe, tag_ids)
    str_tags = tag_ids.map {|id| "0#{id}" if id.to_s.length==1}.join('')
    "#{recipe.taste}_#{str_tags}_#{recipe.time_required}"
  end
end
