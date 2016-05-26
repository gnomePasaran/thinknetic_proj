require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to answer from community
  As an authentificated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'Authentificated user creates question with valit attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test test'
    click_on 'Create'

    expect(page).to have_content 'Test question'
  end

  scenario 'Authentificated user creates question with invalit attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Body', with: 'Test test'
    click_on 'Create'

    expect(page).to have_content 'Title can\'t be blank'
  end


  scenario 'Non-Authentificated user creates question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end