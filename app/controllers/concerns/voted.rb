module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :vote_cancel]
    before_action :can_vote?,   only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    vote = @votable.vote_up(current_user)
    render json: { id: @votable.id, score: vote.score, total_score: @votable.get_score }
  end

  def vote_down
    vote = @votable.vote_down(current_user)
    render json: { id: @votable.id, score: vote.score, total_score: @votable.get_score }
  end

  def vote_cancel
    @votable.vote_cancel(current_user)
    render json: { id: @votable.id, score: false, total_score: @votable.get_score }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def can_vote?
    head :forbidden if current_user.id == @votable.user_id
  end

end