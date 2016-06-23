require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_pair(:user) }

  it 'should send email to everyone' do
    users.each { |user| expect(DailyDigestJob).to receive(daily_digest).with(user).and_call_original }
    DailyDigestJob.perform_now
  end
end
