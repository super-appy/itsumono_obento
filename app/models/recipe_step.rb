class RecipeStep < ApplicationRecord
  validates :number, :description, presence: true

  belongs_to :recipe
end
