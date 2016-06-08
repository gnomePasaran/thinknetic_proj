require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in_with_oauth(user, provider)
    sign_in_and_redirect user, event: :authentication
    flash[:notice] = t('devise.omniauth_callbacks.success', kind: provider.to_s.camelize) if is_navigational_format?
  end

  def redirect_if_signed_in(path = root_path)
    redirect_to path if signed_in?
  end


  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    respond_to do |format|
      format.html { redirect_to(request.referrer || root_path) }
      format.any(:js, :json) { head :forbidden }
    end
  end
end
