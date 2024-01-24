class RecipeRecommendationService
  def initialize(user)
    @user = user
  end

  def recommended_recipes
    bookmarked_recipe_ids = @user.bookmarked_recipes.pluck(:recipe_id)

    if @user.user_search_logs.present? && @user.bookmarked_recipes.present?
      if [true, false].sample # ランダムに選択
        return [set_recommended_recipes_from_search_history(bookmarked_recipe_ids), 'search_history']
      else
        return [ set_recommended_recipes_from_bookmarks(bookmarked_recipe_ids), 'bookmarks' ]
      end
    elsif @user.user_search_logs.present?
      return [set_recommended_recipes_from_search_history(bookmarked_recipe_ids), 'search_history']
    elsif @user.bookmarked_recipes.present?
      return [ set_recommended_recipes_from_bookmarks(bookmarked_recipe_ids), 'bookmarks' ]
    else
      return [[], nil]
    end
  end

  private

  def search_params
    JSON.parse(@user.user_search_logs.sample.search_params) if @user.user_search_logs.size != 0
  end

  def set_recommended_recipes_from_search_history(bookmarked_recipe_ids)
    # search_params から直接検索条件を取得
    time_required = search_params["time_required_eq"]
    taste = search_params["taste_eq"]

    # ActiveRecordクエリを使用してレシピを検索
    recipes = Recipe.all
    recipes = recipes.where(time_required: time_required) if time_required.present?
    recipes = recipes.where(taste: taste) if taste.present?
    recipes = recipes.where.not(id: bookmarked_recipe_ids) if bookmarked_recipe_ids.present?

    # 最終的な検索結果からランダムに3つ選択
    recipes.sample(3)
  end

  def set_recommended_recipes_from_bookmarks(bookmarked_recipe_ids)
    bookmarked_recipes = @user.bookmarked_recipes.order(created_at: :desc).take(3)
    selected_recipe = bookmarked_recipes.sample.recipe
    recipes = Recipe.where(time_required: selected_recipe.time_required, taste: selected_recipe.taste)
    recipes = recipes.where.not(id: bookmarked_recipe_ids)
    recipes.sample(3)
  end
end