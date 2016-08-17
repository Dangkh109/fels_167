class ResultsController < ApplicationController
  before_action :find_category
  def index
    if params[:category_id].nil?
      @lessons = current_user.lesson.select{|x| x.is_completed}.sort{
        |x,y| y.updated_at <=> x.updated_at}
      @results = @lessons.paginate page: params[:page],
        per_page: Settings.per_page
    else
      if @category.nil?
        flash[:danger] = t :not_exist_data
        redirect_to results_path
      else
        @lessons = current_user.lesson.select{
          |x| x.is_completed && x.category_id == @category.id}.sort{
          |x,y| y.updated_at <=> x.updated_at}
        @results = @lessons.paginate page: params[:page],
          per_page: Settings.per_page
      end
    end
  end

  def show
    @lesson = Lesson.find_by id: params[:id]
    if @lesson.nil?
      flash[:danger] = t :not_exist_data
      redirect_to results_path
    else
      if @lesson.is_completed
        @results = @lesson.results
        @words = []
        @results.each do |x|
          @words.push x.word
        end
      else
        flash[:danger] = params
        redirect_to results_path
      end
    end
  end

  private
  def find_category
    @category = Category.find_by id: params[:category_id]
  end
end
