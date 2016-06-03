feature 'Mailer' do
  background do
    # will clear the message queue
    clear_emails
    visit email_trigger_path
    # Will find an email sent to test@example.com
    # and set `current_email`
    open_email('test@example.com')
  end

  scenario 'following a link' do
    current_email.click_link 'your profile'
    expect(page).to have_content 'Profile page'
  end

  scenario 'testing for content' do
    expect(current_email).to have_content 'Hello Joe!'
  end
end