class Admin::CategoriesController < ApplicationController
  include Admin::CategoriesHelper
  before_action :verify_admin

  def index
    @categories = Category.order(created_at: :desc).
      paginate page: params[:page], per_page: Settings.per_page
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    respond_to do |format|
      if @category.save
        @category.create_activitie_create_category current_user.id
        format.json {render json: to_json(@category)}
      end
    end
  end

  def destroy
    if params[:category_ids].nil?
      if Category.destroy params[:id]
        flash[:success] = t(:delete_success)
      else
        flash[:danger] = t(:delete_fail)
      end
    else
      @categories = Category.find_ids params[:category_ids]
      index_delete_success = []
      if @categories
        @categories.each do |category|
          if Category.destroy category
            index_delete_success.append(category.id)
          end
        end
        flash[:success] = t(:delete_success) + index_delete_success.join(",")
      else
        flash[:danger] = t :must_select
      end
    end
    redirect_to admin_categories_path
  end

  def update
    @category = Category.find_by id: params[:id]
    respond_to do |format|
      if @category && @category.update_attributes(category_params)
        format.json {render json: to_json(@category)}
      end
    end
  end

  private
  def category_params
    params.require(:category).permit :name, :description
  end
end
