class Tag < ApplicationRecord
  has_many :recipe_tags
  has_many :recipes, through: :recipe_tags

  enum category: { vegetable: 0, meat_fish: 1, others: 2}

  validates :category, :name, presence: true
end
