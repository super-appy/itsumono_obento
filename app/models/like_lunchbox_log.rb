class LikeLunchboxLog < ApplicationRecord
  belongs_to :user
  belongs_to :lunchbox_log

  validates :user_id, uniqueness: { scope: :lunchbox_log_id }
end
