require 'rails_helper'

feature 'Answer question', %q{
  In order to answer question
  As an user
  I want to be able to answer the question
} do

  given(:user) { create(:user) }
  before { @question = create(:question) }

  scenario 'Authentificated user answer the question' do
    sign_in(user)

    visit questions_path
    click_on 'To answer'

    visit new_question_answer_path(@question)
    fill_in 'Body', with: 'Test answer'
    click_on 'Create'

    expect(current_path).to eq question_path @question
  end

  scenario 'Non-authentificated user answer the question' do
    visit questions_path
    click_on 'To answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end