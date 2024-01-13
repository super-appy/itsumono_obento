class BookmarkedRecipesController < ApplicationController

  def cooked
    @tags = Tag.all
    @q = current_user.bookmarked_recipes.cooked.joins(:recipe).ransack(params[:q])
    @q.sorts = "updated_at desc" if @q.sorts.empty?
    @bookmarked_recipes = @q.result.includes(recipe: :tags).distinct.page(params[:page])
  end

  def want_to_cook
    @tags = Tag.all
    @q = current_user.bookmarked_recipes.want_to_cook.joins(:recipe).ransack(params[:q])
    @q.sorts = "updated_at desc" if @q.sorts.empty?
    @bookmarked_recipes = @q.result.includes(recipe: :tags).distinct.page(params[:page])
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    current_user.bookmark(@recipe)
  end

  def edit
    @bookmarked_recipe = current_user.bookmarked_recipes.find(params[:id])
  end

  def update
    @bookmarked_recipe = current_user.bookmarked_recipes.find(params[:id])
    if @bookmarked_recipe.update(bookmarked_recipe_params)
      redirect_to cooked_bookmarked_recipes_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe = current_user.bookmarked_recipes.find(params[:id]).recipe
    current_user.unbookmark(@recipe) if @recipe.present?
  end

  private

  def bookmarked_recipe_params
    params.require(:bookmarked_recipe).permit(:comment, :repeat).merge(status: 1)
  end
end
