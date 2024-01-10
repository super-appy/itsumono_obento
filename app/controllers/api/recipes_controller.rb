module Api
  class RecipesController < ApplicationController
    before_action :set_select_lists, only: :new
    skip_before_action :require_login


    def new
      if api_request_allowed?
        @recipe = Recipe.new
      else
        redirect_to root_path, alert: 'レシピの生成は1日1度までです'
      end
    end

    def create
      @recipe = Recipe.new(recipe_params)
      begin
        api_response = Openai::ApiResponseService.new.call(recipe_params)
        @recipe = Recipe.create_from_api(recipe_params, api_response)
        if @recipe.save
          set_api_request_cookie
          redirect_to recipe_path(@recipe)
        else
          set_select_lists
          render :new, status: :unprocessable_entity
        end
      rescue Openai::UnauthorizedError,
            Openai::TooManyRequestsError,
            Openai::InternalServerError,
            Openai::ServiceUnavailableError,
            Openai::TimeoutError => e
        @error_message = e.message
        set_select_lists
        render :new, status: :unprocessable_entity
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
