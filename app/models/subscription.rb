class Subscription < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, :user_id, presence: true
  validates :question_id, uniqueness: { scope: :user_id }
end
