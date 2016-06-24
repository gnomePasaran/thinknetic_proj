require 'rails_helper'

RSpec.describe QuestionNotificationJob, type: :job do
  let!(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let!(:subscriptions) { create_pair(:subscription, question: question) }
  let(:non_subscriber) { create(:user) }

  it 'sends mail to question subscribers' do
    question.subscriptions.each { |subscription| expect(NotificationMailer)
      .to receive(:question_notification).with(question, subscription.user).and_call_original }

    QuestionNotificationJob.perform_now(answer)
  end
end