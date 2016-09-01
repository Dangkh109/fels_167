class Lesson < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :category
  has_many :results
  accepts_nested_attributes_for :results,
    reject_if: proc{|attributes| attributes["word_answer_id"].blank?}
  after_create :create_data
  after_update :create_activities_finish
  validate :check_word

  protected
  def check_word
    @words = self.category.words.take Settings.take_num_lesson
    if @words.count < Settings.take_num_lesson
      errors.add :not_enough_word, I18n.t(:not_enough_word)
    end
  end

  def create_data
    @words = self.category.words.shuffle.take Settings.take_num_lesson
    @words.each do |word|
      self.results.create(word_id: word.id, word_answer_id: 0, is_correct: false)
    end
    create_activities Settings.action_type.create_lesson,
      I18n.t(:create_new_lesson), lesson_path(self.id)

  end

  def create_activities_finish
    create_activities Settings.action_type.finish_lesson,
      I18n.t(:finish_lesson), result_path(self.id)
  end

  def create_activities action_type, content, link
    Activity.create action_type: action_type, user_id: self.user_id,
      target_id: self.id, content: content, link: link
  end
end
