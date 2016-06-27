require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe '#daily_digest' do
    let(:user) { create(:user) }
    let(:questions) { create_pair(:question) }
    let(:email) { DailyDigestMailer.daily_digest(user, questions) }
    let(:old_question) { create(:question, title: 'Old question', created_at: Time.now - 2.days) }

    it 'delivered to the user' do
      expect(email.to[0]).to eq user.email
    end

    it 'contains title and link to questions' do
      questions.each do |question|
        expect(email.body).to have_content question.title
        expect(email.body).to have_link(question.title, href: question_url(question))
      end
    end

    it 'does not contain title and link to old question' do
      expect(email.body).not_to have_content old_question.title
      expect(email.body).not_to have_link(old_question.title, href: question_url(old_question))
    end
  end
end