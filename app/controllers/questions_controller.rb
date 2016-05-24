class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  before_action :load_question, only: [:edit, :show, :update, :destroy, :access, :vote_up, :vote_down, :vote_cancel]
  before_action :access, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = current_user.questions.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def vote_up
    if current_user.id == @question.user_id
      redirect_to @question
    else
      @question.vote_up(current_user)
      render json: { id: @question.id, total_score: @question.get_score }
    end
  end

  def vote_down
    if current_user.id == @question.user_id
      redirect_to @question
    else
      @question.vote_down(current_user)
      render json: { id: @question.id, total_score: @question.get_score }
    end
  end

  def vote_cancel
    if current_user.id == @question.user_id
      redirect_to @question
    else
      @question.vote_cancel(current_user)
      render json: { id: @question.id, total_score: @question.get_score }
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def access
    redirect_to @question unless current_user.id == @question.user_id
  end
end
