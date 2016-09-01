class Category < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  has_many :lessons
  has_many :words, dependent: :destroy
  scope :previous, ->(id) {where("id < ?", id).last}
  scope :next, ->(id) {where("id > ?", id).first}
  validates :name, presence: true, length: {maximum: 45}, uniqueness: true
  validates :description, presence: true, length: {maximum: 255}

  class << self
    def find_ids ids
      begin
        @categories = self.find ids
      rescue ActiveRecord::RecordNotFound
        return nil
      else
        return @categories
      end
    end
  end

  def create_activitie_create_category id
    Activity.create action_type: Settings.action_type.create_category,
      user_id: id, target_id: self.id,
      content: I18n.t(:create_category), link: admin_category_path(id: self.id)
  end
end
