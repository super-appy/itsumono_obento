class Recipe < ApplicationRecord
  belongs_to :user, optional: true
  has_many :bookmarked_recipes

  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags
  accepts_nested_attributes_for :recipe_tags, reject_if: :all_blank, allow_destroy: true

  has_many :recipe_ingredients, dependent: :destroy
  accepts_nested_attributes_for :recipe_ingredients, reject_if: :all_blank, allow_destroy: true

  has_many :recipe_steps, dependent: :destroy
  accepts_nested_attributes_for :recipe_steps, reject_if: :all_blank, allow_destroy: true

  enum time_required: { under_10: 0, minutes_10: 1, minutes_20: 2, over_20: 3 }
  enum taste: { japanese: 0, chinese: 1, western:2 }

  def self.ransackable_attributes(*)
    ["taste", "tag_ids", "time_required", "title", "created_at"]
  end

  def self.ransackable_associations(*)
    ["recipe_tags", "tags"]
  end

  def make_taste_tag_time(tag_ids)
    formatted_tag_ids = tag_ids.map { |id| id.to_s.rjust(2, '0') }
    str_tags = formatted_tag_ids.join('')
    "#{taste}_#{str_tags}_#{time_required}"
  end

  def self.build_with_ingredients_and_steps
    recipe = new
    3.times do
      recipe.recipe_ingredients.build
      recipe.recipe_steps.build
    end
    recipe
  end

  def self.create_from_api(params, api_resp)
    api_resp_name = api_resp.match(/(?<=:).*/)[0]
    api_resp_ingredients = api_resp.match(/(?<=材料\(一人前\):\n)[\s\S]*(?=\n\n手順)/)[0]
    api_resp_steps = api_resp.match(/(?<=手順:\n)[\s\S]*/)[0]
    taste_tag_time = make_taste_tag_time(params[:taste], params[:tag_ids], params[:time_required])

    new(params.merge(
      api_resp: api_resp,
      title: api_resp_name,
      api_ingredients: api_resp_ingredients,
      api_steps: api_resp_steps,
      taste_tag_time: taste_tag_time
    ))
  end

  def self.make_taste_tag_time(taste, tag_ids, time_required)
    formatted_tag_ids = tag_ids.reject(&:blank?).map { |id| id.to_s.rjust(2, '0') }
    str_tags = formatted_tag_ids.join('')
    "#{taste}_#{str_tags}_#{time_required}"
  end

  scope :sorted_by_creation, -> { order(created_at: :desc) }


  # validates :title, :time_required, :taste, :taste_tag_time, presence: true
  validates :title, :time_required, :taste, presence: true
  validates :title, length: { maximum: 50 }
  validates :api_ingredients, :api_steps, length: { maximum: 500 }

end
