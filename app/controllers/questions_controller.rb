class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  protect_from_forgery except: :toggle_best

  before_action :load_question, only: [:edit, :show, :update, :destroy, :accept, :toggle_best]
  before_action :accept, only: [:update, :destroy, :toggle_best]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = current_user.questions.new
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

  def toggle_best
    answer = Answer.find(params[:answer_id])
    answer.toggle_best
    redirect_to @question
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def accept
    redirect_to @question unless current_user == @question.user
  end
end
