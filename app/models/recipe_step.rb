class RecipeStep < ApplicationRecord
  belongs_to :recipe

  validates :number, :description, presence: true
  validates :description, length: { maxium: 500 }
end
