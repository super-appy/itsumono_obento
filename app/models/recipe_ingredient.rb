class RecipeIngredient < ApplicationRecord
  validates :name, :quantity, presence: true

  belongs_to :recipe
end
