class Question < ActiveRecord::Base
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :answers, -> { order(is_best: :desc).order(created_at: :asc) }, dependent: :destroy

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  has_many :votes, as: :votable, dependent: :destroy

  validates :title, :body, :user_id, presence: true

  def vote(user, score)
    p score
    if (vote = self.votes.find_by_user_id(user))
      vote.score!
    else
      self.votes.create(user: user, score: score)
    end
  end

  def get_score
    result = 0
    self.votes.each do |vote|
      if vote.like?
        result += 1
      elsif vote.dislike?
        result -= 1
      end
    end
    result
  end
end
