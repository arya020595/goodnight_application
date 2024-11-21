class User < ApplicationRecord
  has_many :follows, foreign_key: :follower_id
  has_many :followed_users, through: :follows, source: :followed
  has_many :followers, through: :follows, source: :follower
  has_many :sleep_records

  validates :name, presence: true
end
