class Question < ActiveRecord::Base
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :answers, -> { order(is_best: :desc).order(created_at: :asc) }, dependent: :destroy

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments

  validates :title, :body, :user_id, presence: true
end
