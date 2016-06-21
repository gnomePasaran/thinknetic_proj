class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:index, :create]
  before_action :answer_params, only: [:create]

  def index
    @answers = @question.answers
    respond_with @answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    authorize Answer
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
    respond_with @answer
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
