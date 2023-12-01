class Recipe < ApplicationRecord
  belongs_to :user, optional: true
  has_many :recipe_tags
  has_many :tags, through: :recipe_tags
  has_many :bookmarked_recipes
  has_many :recipe_ingredients
  has_many :recipe_steps

  validates :title, :time_required, :taste, :taste_tag_time, presence: true
  validates :title, length: { maximum: 50 }
  validates :api_ingredients, :api_steps, length: { maximum: 500 }

end
