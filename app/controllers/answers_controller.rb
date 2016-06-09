class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :load_answer, only: [:load_question, :edit, :update, :destroy, :access, :toggle_best]
  before_action :load_question, only: [:create, :update, :destroy, :access]
  before_action :access, only: [:update, :destroy]
  ### ???

  include Voted

  respond_to :js

  def create
    authorize Answer
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
    respond_with @answer
  end

  def update
    authorize @answer
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    authorize @answer
    respond_with(@answer.destroy)
  end

  def toggle_best
    authorize @answer
    @answer.toggle_best
    redirect_to @answer.question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    ### ??? нужно ли выносить этот метод в before_action
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def access
    redirect_to @question unless current_user.id == @answer.user_id
  end
end
