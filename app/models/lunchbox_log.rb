class LunchboxLog < ApplicationRecord
  belongs_to :user
  has_many :like_lunchbox_logs
  has_many :bookmarked_recipes

  enum published_status: { private: 0, users_only: 1, public: 2 }, _prefix: true

  validates :cooked_date, presence: true
  validates :comment, length: { maximum: 500 }
  validates :original_menu, length: { maximum: 50 }
  # imageはpngかjpeg,jpgのみ
end
