class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :posts, dependent: :destroy
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :user
  has_many :comments

  def follow(follow_user_id)
    relationships.create(follow_id: follow_user_id)
  end

  def unfollow(unfollow_user_id)
    relationship = relationships.find_by(follow_id: unfollow_user_id)
    relationship.destroy
  end

  def following?(user_id)
    relationships.find_by(follow_id: user_id).present?
  end

  def same_user?(user_id)
    id == User.find(user_id).id
  end

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.now
      user.build_profile
      user.profile.name = "ゲスト"
    end
  end
end
