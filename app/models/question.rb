class Question < ActiveRecord::Base
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :answers, -> { order(is_best: :desc).order(created_at: :asc) }, dependent: :destroy

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  has_many :votes, as: :votable, dependent: :destroy

  validates :title, :body, :user_id, presence: true

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
