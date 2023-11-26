class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :email, :crypted_password, :name, presence: true
  validates :crypted_password, length: { minimum: 6 }
end
