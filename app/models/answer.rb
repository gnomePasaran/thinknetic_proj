class Answer < ActiveRecord::Base
  belongs_to :question, foreign_key: :question_id

  validates :question_id, :body, presence: true
end
