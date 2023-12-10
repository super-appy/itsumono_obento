class Recipe < ApplicationRecord
  belongs_to :user, optional: true
  has_many :recipe_tags
  has_many :tags, through: :recipe_tags
  has_many :bookmarked_recipes

  has_many :recipe_ingredients, inverse_of: :recipe
  accepts_nested_attributes_for :recipe_ingredients, reject_if: :all_blank, allow_destroy: true

  has_many :recipe_steps, inverse_of: :recipe
  accepts_nested_attributes_for :recipe_steps, reject_if: :all_blank, allow_destroy: true

  enum time_required: { under_10: 0, minutes_10: 1, minutes_20: 2, over_20: 3 }
  enum taste: { japanese: 0, chinese: 1, western:2 }

  # validates :title, :time_required, :taste, :taste_tag_time, presence: true
  validates :title, :time_required, :taste, presence: true
  validates :title, length: { maximum: 50 }
  validates :api_ingredients, :api_steps, length: { maximum: 500 }

end
