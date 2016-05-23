class Vote < ActiveRecord::Base
  belongs_to :user

  belongs_to :votable, polymorphic: true

  validates :user_id, :score, presence: true

  enum score: { like: 1, neutral: 0, dislike: -1 }
end
