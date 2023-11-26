class Tag < ApplicationRecord
  validates :category, :name, presence: true
end
