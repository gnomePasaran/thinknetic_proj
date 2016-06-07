class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def update?
    user.present? && (user.admin? || user.id == record.user_id)
  end

  def destroy?
    user.present? && (user.admin? || user.id == record.user_id)
  end

  def toggle_best?
    user.present? && (user.admin? || user.id == record.user_id)
  end

  def vote?
    user.present? && user.id != record.user_id
  end
end
