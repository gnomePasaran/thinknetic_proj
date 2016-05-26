require_relative '../acceptance_helper'

feature 'Add comment', %q{
  In order to comment question
  As an user
  I want to be able to comment the question
} do

  given(:user) { create(:user) }
  given(:not_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authentificated user comment the question with valid', js: true do
    sign_in(user)
    visit question_path question

    within '.question' do
      expect(page).to have_content 'Add comment'
      click_on 'Add comment'
    end
    within '.comment' do
      fill_in 'Your comment', with: 'Question comment'
      click_on 'Save comment'
    end

    within '.question .comment' do
      expect(page).to have_content 'Question comment'
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end
  end

  # scenario 'Non-authentificated user answer the question', js: true do
  #   visit questions_path
  #   click_on question.title

  #   expect(page).not_to have_selector 'textarea'
  # end

  # scenario 'Non-authentificated user answer the question', js: true do
  #   sign_in(user)

  #   visit question_path question
  #   click_on 'Create answer'

  #   expect(page).to have_content 'Body can\'t be blank'
  # end
end
