class Category < ActiveRecord::Base
  has_many :lessons
  has_many :words, dependent: :destroy
  scope :previous, ->(id) {where("id < ?", id).last}
  scope :next, ->(id) {where("id > ?", id).first}
end
