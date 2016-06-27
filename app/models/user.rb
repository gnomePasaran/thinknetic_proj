class User < ActiveRecord::Base
  has_many :answers,        dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :comments,       dependent: :destroy
  has_many :questions,      dependent: :destroy
  has_many :subscriptions,  dependent: :destroy
  has_many :votes,          dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  def self.find_for_oauth(auth)
    email = auth_email(auth)
    user = find_by(email: email) if email

    if user.present?
      user.create_authorizations(auth)
    elsif email
      user = create_user_from_auth(auth)
    else
      user = nil
    end

    user
  end

  def self.create_user_from_auth(auth)
    user = User.new(email: auth_email(auth), password: Devise.friendly_token[0, 20])
    user.skip_confirmation!
    user.save!
    user.create_authorizations(auth)
    user
  end

  def self.create_user_from_session(auth, email)
    user = User.new(email: email, password: Devise.friendly_token[0, 20])
    user.create_authorizations(auth) if user.save
    user
  end

  def create_authorizations(auth)
    authorizations.create!(provider: auth['provider'], uid: auth['uid'])
  end

  def self.auth_email(auth)
    auth.try(:info).try(:email)
  end
end
