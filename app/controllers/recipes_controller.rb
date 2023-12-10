class RecipesController < ApplicationController
  def new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.new
    @recipe.recipe_steps.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    @recipe.taste_tag_time = 'aaaac'

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
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :time_required, :taste,
      recipe_ingredients_attributes: [:id, :name, :quantity],
      recipe_steps_attributes: [:id, :number, :description])
  end

  def get_response
  end
end
