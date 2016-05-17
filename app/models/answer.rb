class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, :body, :user_id, presence: true

  def toggle_best
    transaction do
      toggle :is_best
      question.answers.where(is_best: true).update_all(is_best: false) if is_best?
      save!
    end
  end
end
