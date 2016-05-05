require 'rails_helper'

feature 'User registration', %q{
  In order to be able to registrate
  As an User
  I want to be able to registrate
} do

  scenario 'User try to registrate' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'User try to registrate with not unique email' do
    user = create(:user)

    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
