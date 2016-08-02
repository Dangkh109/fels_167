class CategoriesController < ApplicationController
  def index
    if params[:categories][:sort] == t(:time)
      @categories = Category.order(:created_at).paginate page: params[:page]
    else
      @categories = Category.order(:name).paginate page: params[:page]
    end
  end

  def new
  end

  def show
    @category = Category.find_by id: params[:id]
  end
end
