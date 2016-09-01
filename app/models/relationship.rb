class Relationship < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  after_create :create_activities_follow
  before_destroy :create_activities_unfollow
  protected


  def create_activities_follow
    create_activities Settings.action_type.follow, I18n.t(:follow)
  end


  def create_activities_unfollow
    create_activities Settings.action_type.unfollow, I18n.t(:unfollow)
  end

  def create_activities action_type, content
    Activity.create action_type: action_type,
      user_id: self.follower_id, target_id: self.followed_id,
      content: content, link: user_path(self.followed_id)
  end
end
