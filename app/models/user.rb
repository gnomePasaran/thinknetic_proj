class User < ActiveRecord::Base
  has_many :answers,        dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :comments,       dependent: :destroy
  has_many :questions,      dependent: :destroy
  has_many :votes,          dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid)
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email)
    if user
      user.create_authozation(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authozation(auth)
    end
    user
  end

  def create_authozation(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
