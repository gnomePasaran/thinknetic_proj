class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  before_action :load_question, only: [:edit, :show, :update, :destroy, :access]
  before_action :access, only: [:update, :destroy]
  after_action  :publicate_question, only: :create
  after_action  :edit_question, only: :update

  include Voted

  respond_to :js
  # respond_to :json, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answer = @question.answers.build
    respond_with(@answer.attachments.build)
  end

  def new
    respond_with(@question = current_user.questions.new)
  end

  def create
    @question = Question.create(question_params.merge(user_id: current_user.id))
    respond_with(@question)
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def publicate_question
    PrivatePub.publish_to '/questions', question: @question.to_json if @question.errors.empty?
  end

  def edit_question
    PrivatePub.publish_to "/questions/#{@question.id}/answer", question: @question.to_json if @question.errors.empty?
  end

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
