class User < ApplicationRecord
  has_many :sleeps, dependent: :destroy
  has_many :followers, class_name: 'Follow', foreign_key: :following_id, dependent: :destroy
  has_many :followings, class_name: 'Follow', foreign_key: :follower_id, dependent: :destroy
  has_many :follower_users, through: :followers, source: :follower
  has_many :following_users, through: :followings, source: :following

  def sleeping?
    sleeps.last&.ongoing?
  end
end
