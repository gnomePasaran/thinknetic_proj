module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    vote = votes.find_or_initialize_by(user: user)
    vote.like!
  end

  def vote_down(user)
    vote = votes.find_or_initialize_by(user: user)
    vote.dislike!
  end


  def vote_cancel(user)
    if vote = votes.find_by(user: user)
      vote.destroy
    else
      false
    end
  end

  def get_score
    self.votes.sum(:score)
  end

  def get_vote(user)
    self.votes.find_by_user_id(user)
  end

end