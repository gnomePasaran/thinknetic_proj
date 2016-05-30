class Comment < ActiveRecord::Base
  belongs_to :user

  belongs_to :commentable, polymorphic: true

  validates :user_id, :commentable, :body, presence: true
end
