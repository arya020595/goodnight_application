class Follow < ApplicationRecord
  # Validations
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
  belongs_to :followed, class_name: 'User', foreign_key: 'followed_id'

  # Ensure follower and followed are not the same
  validate :follower_and_followed_are_different

  # Ensure that a user can follow another user only once
  validates :follower_id, uniqueness: { scope: :followed_id, message: 'You are already following this user' }

  # Ensure the users being followed exist
  validates :follower_id, :followed_id, presence: true
  validate :users_must_exist

  private

  # Custom validation to check if the follower and followed users are the same
  def follower_and_followed_are_different
    return unless follower_id == followed_id

    errors.add(:followed_id, 'You cannot follow yourself')
  end

  # Custom validation to ensure both users exist
  def users_must_exist
    return if User.exists?(follower_id) && User.exists?(followed_id)

    errors.add(:base, 'One or both users do not exist')
  end
end
