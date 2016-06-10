class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :load_answer, only: [:edit, :update, :destroy, :access, :toggle_best]
  before_action :load_question, only: [:create]
  before_action :access, only: [:update, :destroy, :toggle_best]

  include Voted

  respond_to :js

  def create
    authorize Answer
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
    respond_with @answer
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def toggle_best
    @answer.toggle_best
    redirect_to @answer.question
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
    authorize @answer
  end
end
