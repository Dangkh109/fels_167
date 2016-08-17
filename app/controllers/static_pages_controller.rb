class StaticPagesController < ApplicationController
  skip_before_action :logged_in_user

  def home
    if logged_in?
      @categories = Category.take Settings.categories_num_homepage
      @total_lesson = current_user.lesson.select{
        |x| x.is_completed == false}.sort{|x,y| y.updated_at <=> x.updated_at}
      @lessons = @total_lesson.paginate page: params[:page],
        per_page: Settings.lesson_home
    end
  end

  def help
  end

  def about
  end
end
