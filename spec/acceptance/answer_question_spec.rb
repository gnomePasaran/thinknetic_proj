require 'rails_helper'

feature 'Answer question', %q{
  In order to answer question
  As an user
  I want to be able to answer the question
} do

  given(:user) { create(:user) }
  before { @question = create(:question) }

  scenario 'Authentificated user answer the question with valid' do
    sign_in(user)

    visit questions_path
    click_on @question.title

    click_on 'To answer'
    fill_in 'Body', with: 'Test answer'
    click_on 'Create'

    expect(current_path).to eq question_path @question
    expect(page).to have_content 'Test answer'
  end

  scenario 'Authentificated user answer the question with invalid' do
    sign_in(user)

    visit questions_path
    click_on @question.title

    click_on 'To answer'
    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authentificated user answer the question' do
    visit questions_path
    click_on 'To answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end