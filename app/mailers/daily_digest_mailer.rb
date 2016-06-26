class DailyDigestMailer < ApplicationMailer
  def daily_digest(user, questions)
    @questions = questions
    mail(to: user.email, subject: 'Daily digest' )
  end
end
