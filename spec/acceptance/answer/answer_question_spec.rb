require_relative '../acceptance_helper'

feature 'Answer question', %q{
  In order to answer question
  As an user
  I want to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:not_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authentificated user answer the question with valid', js: true do
    sign_in(user)

    visit questions_path
    click_on question.title

    fill_in 'Your answer', with: 'Test answer'
    click_on 'Create answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Test answer'
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end
  end

  scenario 'Non-authentificated user answer the question', js: true do
    visit questions_path
    click_on question.title

    expect(page).not_to have_selector 'textarea'
  end

  scenario 'Non-authentificated user answer the question', js: true do
    sign_in(user)

    visit question_path question
    click_on 'Create answer'

    expect(page).to have_content 'Body can\'t be blank'
  end
end
