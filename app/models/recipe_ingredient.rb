class RecipeIngredient < ApplicationRecord
  belongs_to :recipe

  validates :name, :quantity, presence: true
  validates :name, :quantity, length: { maximum: 20 }

end
