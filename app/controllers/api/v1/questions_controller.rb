class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question_params, only: :create

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end

  def create
    authorize Question
    @question = Question.create(question_params.merge(user_id: current_user.id))
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
