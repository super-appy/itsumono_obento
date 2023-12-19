class BookmarkedRecipe < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  # ブックマークしているレシピを引っ張ってきたい
  enum status: { want_to_cook: 0, cooked: 1 }

  validates :user_id, uniqueness: { scope: :recipe_id }
  validates :comment, length: { maximum: 500 }

  # statusを「作った」にするときはrepeatは選択必須
  # validates :repeat, presence: true if status === 1

end
