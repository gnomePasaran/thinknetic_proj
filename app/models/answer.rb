class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  has_many :votes, as: :votable, dependent: :destroy

  validates :question_id, :body, :user_id, presence: true

  def toggle_best
    transaction do
      toggle :is_best
      question.answers.where(is_best: true).update_all(is_best: false) if is_best?
      save!
    end
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
