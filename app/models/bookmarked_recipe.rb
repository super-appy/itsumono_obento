class BookmarkedRecipe < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  enum status: { want_to_cook: 0, cooked: 1 }

  def self.ransackable_attributes(*)
    ["repeat", "status", "updated_at", "user_id"]
  end

  def self.ransackable_associations(*)
    ["recipe", "user", "tags", "recipe_tags"]
  end

  validates :user_id, uniqueness: { scope: :recipe_id }
  validates :comment, length: { maximum: 500 }

  # statusを「作った」にするときはrepeatは選択必須
  # validates :repeat, presence: true if status === 1

end
