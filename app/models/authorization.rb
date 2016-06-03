class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :uid, uniqueness: { scope: :provider }
  validates :provider, :uid, presence: true
end
