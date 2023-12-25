class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :recipes
  has_many :bookmarked_recipes
  has_many :lunchbox_logs
  has_many :like_lunchbox_logs, dependent: :destroy
  has_many :liked_lunchbox_logs, through: :like_lunchbox_logs, source: :lunchbox_log

  enum line_registerd: { yet: 0, done: 1 }

  def own?(object)
    id == object&.user_id
  end

  def like(lunchbox_log)
    liked_lunchbox_logs << lunchbox_log
  end

  def unlike(lunchbox_log)
    liked_lunchbox_logs.destroy(lunchbox_log)
  end

  def like?(lunchbox_log)
    liked_lunchbox_logs.include?(lunchbox_log)
  end


  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 20 }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  # avatorはpngかjpeg,jpgのみ
end
