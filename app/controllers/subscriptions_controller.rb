class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create, :destroy]

  respond_to :json

  def create
    authorize Subscription
    respond_with @question.subscriptions.create(user: current_user), location: @question
  end

  def destroy
    @subscription = @question.subscriptions.find_by(user: current_user)
    respond_with(authorize @subscription.destroy)
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
end
