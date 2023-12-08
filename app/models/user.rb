class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :recipes
  has_many :bookmarked_recipes
  has_many :like_lunchbox_logs
  has_many :lunchbox_logs

  enum line_registerd: { yet: 0, done: 1 }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 20 }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  # avatorはpngかjpeg,jpgのみ
end
