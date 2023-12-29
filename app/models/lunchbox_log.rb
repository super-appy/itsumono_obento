class LunchboxLog < ApplicationRecord
  belongs_to :user
  has_many :bookmarked_recipes
  has_many :like_lunchbox_logs, dependent: :destroy
  has_many :liked_lunchbox_logs, through: :like_lunchbox_logs, source: :lunchbox_log

  mount_uploader :image, LunchboxImageUploader

  enum published_status: { private: 0, users_only: 1, public: 2 }, _prefix: true

  def start_time
    self.cooked_date
  end

  validates :cooked_date, presence: true
  validates :comment, length: { maximum: 500 }
  validates :original_menu, length: { maximum: 50 }
  # imageはpngかjpeg,jpgのみ
end
