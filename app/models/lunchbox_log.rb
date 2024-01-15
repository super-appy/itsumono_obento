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

  validate :one_entry_per_day, on: :create
  validates :cooked_date, presence: true
  validates :comment, presence: true, length: { maximum: 150 }
  validates :original_menu, presence: true, length: { maximum: 50 }
  validates :published_status, presence: true

  private

  def one_entry_per_day
    # 既に同じ日にログが存在するか確認
    existing_log = user.lunchbox_logs.where(cooked_date: cooked_date.beginning_of_day..cooked_date.end_of_day).exists?
    errors.add(:base, "お弁当のログは1日1つしか登録できません。") if existing_log
  end
end
