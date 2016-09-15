class User < ActiveRecord::Base
  has_many :activities
  has_many :lesson
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_attached_file :avatar,
    styles: {small: "32x32", medium: "64x64", large: "128x128"},
    default_url: "/images/medium/missing.png"
  before_save ->{self.email = email.downcase}
  validates :name, presence: true, length: {maximum: 45}, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  validates_attachment :avatar, content_type: {content_type: "image/.*"},
    size: {in: 0..100.kilobytes}

  def is_user? user
    self == user
  end

  def follow user
    active_relationships.create! followed_id: user.id
  end

  def unfollow user
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def check_following user
    following.include? user
  end

  def is_admin?
    self.is_admin
  end
end
