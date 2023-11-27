class BookmarkedRecipe < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  # ブックマークしているレシピを引っ張ってきたい

  validates user_id, uniqueness: { scope: :recipe_id }
  validates :comment, length: { maximun: 500 }

  # 最初かstatusを「作りたい」で登録
  # statusを「作った」にするときはrepeatは選択必須

end
