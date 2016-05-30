require_relative '../acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I want to be able to edit the question
} do

  given(:user) { create(:user) }
  given(:not_owner) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthentificated user try to edit answer', js: true do
    visit question_path(question)

    expect(page).not_to have_link 'Edit answer'
  end

  describe 'Authentificated user do' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Author sees edit link' do
      expect(page).to have_link 'Edit question'
    end

    scenario 'Author try to edit his question with valid attributes', js: true do
      click_on 'Edit'
      fill_in 'Your question', with: 'Edited question'
      click_on 'Save edits'

      expect(page).to have_content 'Edited question'
      expect(page).to have_link 'Edit question'
    end

    scenario 'Author try to edit his question with invalid attributes', js: true do
      click_on 'Edit'
      fill_in 'Your question', with: ''
      click_on 'Save edits'

      expect(page).to have_content 'Title can\'t be blank'
    end
  end

  scenario 'Authentificated user try to edit not his answer' do
    sign_in(not_owner)

    visit question_path(question)
    expect(page).not_to have_link 'Edit question'
  end
end
