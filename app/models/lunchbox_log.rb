class LunchboxLog < ApplicationRecord
  belongs_to :user
  has_many :like_lunchbox_logs
  has_many :bookmarked_recipes

  validates :cooked_date, :published_status, presence: true
  validates :comment, length: { maximun: 500 }
  validates :original_menu, length: { maximun: 50 }
  # imageはpngかjpeg,jpgのみ
end
