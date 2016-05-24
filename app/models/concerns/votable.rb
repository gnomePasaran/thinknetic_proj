module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, score)
    if vote = self.votes.find_by_user_id(user)
      if Vote.respond_to?(score) && Vote.scores.to_s.include?(score)
        vote.public_send("#{score}!")
      end
    else
      vote = self.votes.create(user: user, score: score)
    end
    vote
  end

  def get_score
    self.votes.sum(:score)
  end

  def get_vote(user)
    self.votes.find_by_user_id(user)
  end

end