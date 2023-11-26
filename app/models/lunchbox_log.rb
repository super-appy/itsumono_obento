class LunchboxLog < ApplicationRecord
  validates :cooked_date, :publishment_status, presence: true

  belongs_to :user
end
