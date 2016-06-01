require_relative '../acceptance_helper'

feature 'User sign in through twitter', %q{
  In order to be able to sign in
  As an User
  I want to be able to sign in
} do

describe "access top page" do
  it "can sign in user with Twitter account" do
    visit root_path
    page.should have_content("Sign in with Twitter")
    mock_auth_hash
    click_link "Sign in"
    page.should have_content("mockuser")  # user name
    page.should have_css('img', :src => 'mock_user_thumbnail_url') # user image
    page.should have_content("Sign out")
  end

  it "can handle authentication error" do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    visit root_path
    page.should have_content("Sign in with Twitter")
    click_link "Sign in"
    page.should have_content('Authentication failed.')
  end
end
