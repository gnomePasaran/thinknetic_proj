# require_relative '../acceptance_helper'

# feature 'confirm registration' do
#   background do
#     clear_emails
#   end

#   context 'twitter registration' do
#     background do
#       mock_auth_hash#(provider: 'twitter', info: nil)
#       visit new_user_session_path
#       click_on 'Sign in with Twitter'
#       # sleep 0.5
#       fill_in 'Email', with: 'test@example.com'
#       click_on 'Continue'
#       open_email('test@example.com')
#     end

#     scenario 'confirm account' do
#       current_email.click_link 'Confirm my account'
#       expect(page).to have_content 'Your email address has been successfully confirmed'
#     end
#   end
# end
