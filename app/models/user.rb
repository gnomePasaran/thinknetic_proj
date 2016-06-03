class User < ActiveRecord::Base
  has_many :answers,        dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :comments,       dependent: :destroy
  has_many :questions,      dependent: :destroy
  has_many :votes,          dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid)
    return authorization.user if authorization

    email = auth.try(:info).try(:email)
    user = User.find_by(email: email)
    if user
      user.create_authozation(auth)
    elsif email
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.zone.now)
      user.create_authozation(auth)
    else
      user = nil
    end
    user
  end

  def create_authozation(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
