module Api
  class RecipesController < ApplicationController
    include SelectListable
    before_action :set_select_lists, only: :new
    skip_before_action :require_login, only: [:new, :create]


    def new
      if can_create_recipe?
        @recipe = Recipe.new
      else
        redirect_to root_path, alert: '本日はすでにレシピを生成しています。レシピの生成は1日1度までです。'
      end
    end

    def create
      if logged_in?
        @recipe = current_user.recipes.build(recipe_params)
      else
        @recipe = Recipe.new(recipe_params)
      end
      @recipe.controller_name = 'api/recipes'

      if @recipe.valid?
        begin
          api_response = Openai::ApiResponseService.new.call(recipe_params)
          @recipe = Recipe.create_from_api(recipe_params, api_response)
          @recipe.controller_name = 'api/recipes'

          if @recipe.save
            session[:from_action] = 'create'
            set_api_request_cookie
            respond_to do |format|
              format.js { render js: "window.hideModal(document.getElementById('modalArea'));" }
              format.html { redirect_to recipe_path(@recipe), notice: 'レシピが生成されました。' }
            end
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
      else
        set_select_lists
        render :new, status: :unprocessable_entity
      end
    end

    private

    def can_create_recipe?
      unless logged_in?
        return api_request_allowed?
      end

      !current_user.recipes.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
                      .where.not(api_resp: [nil, '']).exists?
    end

    def recipe_params
      if logged_in?
        params.require(:recipe).permit(:time_required, :taste, tag_ids:[]).merge(user_id: current_user.id)
      else
        params.require(:recipe).permit(:time_required, :taste, tag_ids:[])
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
