class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    user.present? && (user.admin? || user.id == record.user_id)
  end
end
