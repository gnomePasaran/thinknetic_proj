require 'rails_helper'

RSpec.describe QuestionPolicy do

  let(:guest) { nil }
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:question) { create(:question) }
  let(:user_question) { create(:question, user: user) }


  subject { described_class }

  permissions :create? do
    it { should permit(user, Question) }
    it { should_not permit(guest, Question) }
  end

  permissions :update?, :destroy? do
    it { should permit(admin, question) }
    it { should permit(user, user_question) }
    it { should_not permit(other, user_question) }
    it { should_not permit(guest, user_question) }
  end

  permissions :vote? do
    it { should permit(other, user_question) }
    it { should_not permit(user, user_question) }
  end
end
