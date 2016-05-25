class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :load_answer, only: [:edit, :update, :destroy, :access, :toggle_best]
  before_action :load_question, only: [:create, :update, :destroy, :access, :toggle_best]
  before_action :access, only: [:update, :destroy]

  include Voted

  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def toggle_best
    @answer.toggle_best if current_user.id == @question.user_id
    redirect_to @question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def access
    redirect_to @question unless current_user.id == @answer.user_id
  end
end
