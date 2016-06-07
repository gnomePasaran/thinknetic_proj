require 'rails_helper'

RSpec.describe AnswerPolicy do
  let(:guest) { nil }
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:answer) { create(:answer) }
  let(:question) { create(:question, user: user) }
  let(:user_answer) { create(:answer, question: question, user: user) }


  subject { described_class }

  permissions :create? do
    it { should permit(user, Answer) }
    it { should_not permit(guest, Answer) }
  end

  permissions :update?, :destroy? do
    it { should permit(admin, answer) }
    it { should permit(user, user_answer) }
    it { should_not permit(other, user_answer) }
    it { should_not permit(guest, user_answer) }
  end

  permissions :toggle_best? do
    it { should permit(admin, answer) }
    it { should permit(user, user_answer) }
    it { should_not permit(other, user_answer) }
  end

  permissions :vote? do
    it { should permit(other, user_answer) }
    it { should_not permit(user, user_answer) }
  end
end
