class Recipe < ApplicationRecord
  validates :title, :time_required, :taste, :taste_tag_time, presence: true

  belongs_to :user, optional: true
end
