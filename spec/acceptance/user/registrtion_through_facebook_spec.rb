require_relative '../acceptance_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do

  describe "access top page" do
    it "can sign in user with Facebook account" do
      visit root_path
      click_link "Registration"
      expect(page).to have_content("Sign in with Facebook")
      mock_auth_hash_facebook
      click_link "Sign in with Facebook"
      expect(page).to have_content("Successfully authenticated from Facebook account.")
      expect(page).to have_content("Logout")
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit root_path
      click_link "Registration"
      expect(page).to have_content("Sign in with Facebook")
      click_link "Sign in with Facebook"
      expect(page).to have_content('Could not authenticate you from Facebook because "Invalid credentials"')
    end
  end
end
