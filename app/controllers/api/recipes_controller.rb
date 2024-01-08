module  Api
  class RecipesController < ApplicationController
    before_action :set_select_lists, only: :new
    require "openai"

    def new
      # Cookieの有効期限が切れなければこの画面にアクセスできないようにする
      if api_request_allowed?
        @recipe = Recipe.new
      else
        redirect_to root_path, success: 'レシピの生成は1日1度までです'
      end
    end

    def create
      # privateに入れる（レシピのインスタンスを作る）
        #全部recipe_paramsで大丈夫※今回は使い回しなので
        #以下3行がopenaiのクラス
        api_resp = api(recipe_params)
        set_api_request_cookie
        @recipe = data_change(recipe_params, api_resp)

      if @recipe.save
        redirect_to recipe_path(@recipe)
      else
        Rails.logger.info(@recipe.errors.full_messages)
        set_select_lists
      end
    end

    private

    def recipe_params
      params.require(:recipe).permit(:time_required, :taste, tag_ids:[])
    end

    def set_select_lists
      @tags = Tag.all.group_by(&:category).transform_values do |tags|
        tags.map { |tag| [tag.name, tag.id] }
      end
    end

    def api(params)
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
                  Ingredients: #{array_tag(params)}
                  Taste: #{params[:taste]} style
                  Cooking time: #{params[:time_required]}
                  Plese answer in Japanese.
                  Output should be less than 300 tokens

                  # output
                  タイトル:(no break)
                  材料(一人前):(no more than 6)
                  手順:(only 3 steps)" }],
          })

      response["choices"][0]["message"]["content"]
    end

    # これも切り出せる
    def array_tag(params)
      tag_ids = params[:tag_ids].reject(&:blank?)
      tag_ids.map{ |id| Tag.find(id).name }.join(',')
    end

    def data_change(recipe_params_with_api, api_resp)
      api_resp_name = api_resp.match(/(?<=:).*/)[0]
      api_resp_ingredients = api_resp.match(/(?<=材料\(一人前\):\n)[\s\S]*(?=\n\n手順)/)[0]
      api_resp_steps = api_resp.match(/(?<=手順:\n)[\s\S]*/)[0]

      # 以下はこのコントローラ内
      formatted_tag_ids = recipe_params_with_api[:tag_ids].reject(&:blank?).map { |id| id.to_s.rjust(2, '0') }
      str_tags = formatted_tag_ids.join('')
      taste_tag_time = "#{recipe_params_with_api[:taste]}_#{str_tags}_#{recipe_params_with_api[:time_required]}"
      Recipe.new(recipe_params_with_api.merge(api_resp: api_resp, title: api_resp_name, api_ingredients: api_resp_ingredients, api_steps: api_resp_steps, taste_tag_time: taste_tag_time))
    end

    def api_request_allowed?
      last_request_date = cookies[:last_api_request_date]
      last_request_date.blank? || Date.parse(last_request_date) < Date.today
    end

    def set_api_request_cookie
      cookies[:last_api_request_date] = {
        value: Date.today.to_s,
        expires: Date.today.end_of_day,
        secure: Rails.env.production?,
        httponly: true
      }
    end
  end
end