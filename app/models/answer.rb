class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, :body, :user_id, presence: true

  def toggle_best
  	answer = Answer.find_by(is_best: :true)
    transaction do
      answer.update(is_best: false) if answer.present?
      self.update(is_best: true)
    end
  end
end
