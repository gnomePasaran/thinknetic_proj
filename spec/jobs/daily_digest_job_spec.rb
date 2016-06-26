require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_pair(:user) }
  let(:questions) { create_list(:question) }

  it 'should send email to everyone' do
    users.each do |user|
      expect(DailyDigestJob).to receive(daily_digest).with(user, questions).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
