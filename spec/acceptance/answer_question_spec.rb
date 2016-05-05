require 'rails_helper'

feature 'Answer question', %q{
  In order to answer question
  As an user
  I want to be able to answer the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authentificated user answer the question with valid' do
    sign_in(user)

    visit questions_path
    click_on question.title

    fill_in 'Your answer', with: 'Test answer'
    click_on 'Create'

    within '.answers' do
      expect(page).to have_content 'Test answer'
    end
  end

  scenario 'Non-authentificated user answer the question' do
    visit questions_path
    click_on 'To answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end