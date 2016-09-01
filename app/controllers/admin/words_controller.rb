class Admin::WordsController < ApplicationController
  include Admin::WordsHelper
  include WordsHelper
  before_action :verify_admin
  before_action :load_category, only: [:index, :create, :destroy, :update]

  def index
    @words = @category.words.order(created_at: :desc).paginate page:
      params[:page], per_page: Settings.per_page
    @previous_category = previous_category @category.id
    @next_category = next_category @category.id
    @word = Word.new
  end

  def create
    @word = @category.words.build word_params
    unless correct_answer.nil?
      @word.word_answers[correct_answer].is_correct = true
      if @word.save
        @word.create_activitie_create_word current_user.id
        new_word = to_json @word, correct_answer
        respond_to do |format|
          format.json {render json: new_word}
        end
      end
    end
  end

  def destroy
    if params[:word_ids].nil?
      @words = @category.words.find_by params[:id]
      if @words && @words.destroy
        flash[:success] = t(:delete_success)
      else
        flash[:danger] = t(:delete_fail)
      end
    else
      @words = @category.words.find_ids params[:word_ids]
      index_delete_success = []
      if @words
        @words.each do |word|
          if @category.words.destroy word
            index_delete_success.append(word.id)
          end
        end
        flash[:success] = t(:delete_success) + index_delete_success.join(",")
      else
        flash[:danger] = t :must_select
      end
    end
    redirect_to admin_category_words_path(@category)
  end

  def update
    @word = @category.words.find_by id: params[:id]
    respond_to do |format|
      unless correct_answer.nil?
        @word.word_answers.destroy_all
        if @word.update_attributes word_params
          format.json {render json: to_json(@word, correct_answer)}
        end
      end
    end
  end

  private
  def load_category
    @category = Category.find_by id: params[:category_id]
    if @category.nil?
      flash[:danger] = t :not_exist_category
      redirect_to admin_categories_path
    end
  end

  def correct_answer
    params.require(:is_correct).to_i
  end

  def word_params
    @word_params = params.require(:word).permit :content,
      word_answers_attributes: [:content, :is_correct]
    @word_params[:word_answers_attributes][:"#{correct_answer}"][:is_correct] =
      true
    return @word_params
  end
end
