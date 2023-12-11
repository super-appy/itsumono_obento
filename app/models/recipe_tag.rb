class RecipeTag < ApplicationRecord
  belongs_to :recipe
  belongs_to :tag

  validates :recipe_id, uniqueness: { scope: :tag_id }
end
