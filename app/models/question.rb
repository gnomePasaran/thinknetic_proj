class Question < ActiveRecord::Base
  include Votable
  include Commentable

  belongs_to :user

  has_many :answers, -> { order(is_best: :desc).order(created_at: :asc) }, dependent: :destroy

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  has_many :subscriptions, dependent: :destroy

  validates :title, :body, :user_id, presence: true

  after_create :subscribe_user

  def subscribe_user
    subscriptions.create(user_id: user_id)
  end
end
