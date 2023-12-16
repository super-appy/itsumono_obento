class RecipesController < ApplicationController
  before_action :set_select_lists, only: %i[new new_api]
  require "openai"

  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.new
    @recipe.recipe_steps.new
  end

  def create
    if params[:recipe][:from_new_api] == "true"
      recipe_params_with_api = recipe_params
      api_resp = api(recipe_params_with_api)
      @recipe = data_change(recipe_params_with_api, api_resp)
    else
      @recipe = current_user.recipes.build(recipe_params)
      @recipe.tag_ids = recipe_params[:tag_ids].reject(&:blank?)
      @recipe.taste_tag_time = make_taste_tag_time(@recipe, @recipe.tag_ids)
    end

    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      Rails.logger.info(@recipe.errors.full_messages)
      set_select_lists
      render :new
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @tags = @recipe.tags

    unless @recipe.api_resp
      @recipe_ingredients = RecipeIngredient.where(recipe_id: params[:recipe_id])
      @recipe_steps = RecipeStep.where(recipe_id: params[:recipe_id])
    end
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
    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe), success: 'レシピ編集できた！'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def new_api
    @recipe = Recipe.new
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

  def get_response
  end

  def make_taste_tag_time(recipe, tag_ids)
    str_tags = tag_ids.map {|id| "0#{id}" if id.to_s.length==1}.join('')
    "#{recipe.taste}_#{str_tags}_#{recipe.time_required}"
  end

  def api(params_with_api)
    client = OpenAI::Client.new

    response = client.chat(
        parameters: {
            model: "gpt-4-1106-preview",
            messages: [
              { role: "system", content: "You are professional chef." },
              { role: "user",
                content:
                "Please provide a recipe for a side dish for a lunchbox with the following conditions.

                # conditions
                Ingredients: #{array_tag(params_with_api)}
                Taste: #{params_with_api[:taste]} style
                Cooking time: #{params_with_api[:time_required]}
                Plese answer in Japanese.
                Output should be less than 300 tokens

                # output
                タイトル:
                材料(一人前):(no more than 6)
                手順:(only 3 steps)" }],
        })

    response["choices"][0]["message"]["content"]

  end

  def array_tag(params_with_api)
    tag_ids = params_with_api[:tag_ids].reject(&:blank?)
    tag_ids.map{ |id| Tag.find(id).name }.join(',')
  end

  def data_change(recipe_params_with_api, api_resp)
    api_resp_name = api_resp.match(/(?<=: ).*(?=\n\n材料)/)[0]
    api_resp_ingredients = api_resp.match(/(?<=材料\(一人前\):\n)[\s\S]*(?=\n\n手順)/)[0]
    api_resp_steps = api_resp.match(/(?<=手順:\n)[\s\S]*/)[0]

    taste_tag_time = "#{recipe_params_with_api[:taste]}_#{recipe_params_with_api[:tag_ids].reject(&:blank?).join('')}_#{recipe_params_with_api[:time_required]}"

    Recipe.new(recipe_params_with_api.merge(api_resp: api_resp, title: api_resp_name, api_ingredients: api_resp_ingredients, api_steps: api_resp_steps, taste_tag_time: taste_tag_time))

  end
end
