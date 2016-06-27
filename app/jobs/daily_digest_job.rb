class DailyDigestJob < ActiveJob::Base
  queue_as :mailers

  def perform
  	questions = Questions.where(created_at: Time.current.yesterday.all_day)
  	return unless questions.present?
    User.find_each.each do |user|
      DailyDigestMailer.daily_digest(user, questions).deliver_later 
    end
  end
end
