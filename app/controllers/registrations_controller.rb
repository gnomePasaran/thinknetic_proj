class RegistrationsController < ApplicationController

  # def final_signup
  # end

  def send_confirmation_email
    email = params[:email]
    user = User.find_by(email: params[:email])
    if user.nil?
      authorization = Authorization.find_or_create_by(provider: params[:provider], uid: params[:uid])
      password = Devise.friendly_token[0, 20]
      p authorization
      authorization.user = User.new(email: email, password: password, password_confirmation: password)
      authorization.save!
    end

    redirect_to root_path
  end
end