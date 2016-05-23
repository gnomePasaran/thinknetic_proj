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
end
