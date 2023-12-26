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
    ["taste", "tag_ids", "time_required", "title", "created_at", ]
  end

  def self.ransackable_associations(*)
    ["recipe_tags", "tags"]
  end

  # validates :title, :time_required, :taste, :taste_tag_time, presence: true
  validates :title, :time_required, :taste, presence: true
  validates :title, length: { maximum: 50 }
  validates :api_ingredients, :api_steps, length: { maximum: 500 }

end
