class User < ApplicationRecord
  has_many :recipes
  has_many :bookmarked_recipes
  has_many :like_lunchbox_logs
  has_many :lunchbox_logs

  validates :email, uniqueness: true
  validates :email, :crypted_password, :name, presence: true
  validates :crypted_password, length: { minimum: 6 }
  # avatorはpngかjpeg,jpgのみ
end
