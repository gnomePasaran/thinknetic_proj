require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe '#question_notification' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:email) { NotificationMailer.question_notification(question, question.user) }

    it 'delivered to the user' do
      expect(email.to[0]).to eq question.user.email
    end

    it 'contain link to updated question' do
      expect(email.body).to have_link('check', href: question_url(question))
    end
  end
end