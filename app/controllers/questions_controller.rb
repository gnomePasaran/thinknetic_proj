class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  before_action :load_question, only: [:edit, :show, :update, :destroy, :access]
  before_action :access, only: [:update, :destroy]

  include Voted

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

    respond_to do |format|
      if @question.save
        format.html do
          PrivatePub.publish_to '/questions', question: @question.to_json
          redirect_to @question
        end
      else
        format.html { render :new }
      end
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
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
