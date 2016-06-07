class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :uid, uniqueness: { scope: :provider }
  validates :provider, :uid, presence: true

  def self.find_for_oauth(auth)
    find_by(provider: auth.provider, uid: auth.uid)
  end
end
