class CategoriesController < ApplicationController
  def index
    if params[:categories].nil?
      @categories = Category.order(:name).paginate page: params[:page],
        per_page: Settings.per_page
    else
      if params[:categories][:sort] == t(:time)
        @categories = Category.order(:created_at).paginate page: params[:page],
          per_page: Settings.per_page
      else
        @categories = Category.order(:created_at).paginate page: params[:page],
          per_page: Settings.per_page
      end
    end
  end

  def new
  end

  def show
    @category = Category.find_by id: params[:id]
    if @category.nil?
      flash[:danger] = t :not_exist_category
      redirect_to categories_path
    end
    @lesson = Lesson.new
  end
end
