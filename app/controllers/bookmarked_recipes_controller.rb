class BookmarkedRecipesController < ApplicationController

  def index
    @bookmarked_recipes = current_user.bookmarked_recipes
  end

  def create
    recipe = Recipe.find(params[:recipe_id])
    current_user.bookmarked_recipes.create!(recipe_id: recipe.id, status: 0)
    redirect_to recipes_path
  end

  def edit
    @bookmarked_recipe = current_user.bookmarked_recipes.find(params[:id])
  end

  def update
    @bookmarked_recipe = current_user.bookmarked_recipes.find(params[:id])
    if @bookmarked_recipe.update(bookmarked_recipe_params)
      redirect_to recipes_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    bookmarked_recipe = current_user.bookmarked_recipes.find(params[:id])
    bookmarked_recipe.destroy!
    redirect_to bookmarked_recipes_path, status: :see_other
  end

  private

  def bookmarked_recipe_params
    params.require(:bookmarked_recipe).permit(:comment, :repeat).merge(status: 1)
  end
end
