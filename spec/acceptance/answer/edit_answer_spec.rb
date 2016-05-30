require_relative '../acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I want to be able to edit the answer
} do

  given(:user) { create(:user) }
  given(:not_owner) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthentificated user try to edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit answer'
  end

  describe 'Authentificated user do' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Author sees edit link' do
      within '.answers' do
        expect(page).to have_link 'Edit answer'
      end
    end

    scenario 'Author try to edit his answer with valid attributes', js: true do
      click_on 'Edit answer'
      within "#answer-#{answer.id}" do
        fill_in 'Your answer', with: 'Edited answer'
        click_on 'Save edits'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'Author try to edit his answer with invalid attributes', js: true do
      click_on 'Edit answer'
      within "#answer-#{answer.id}" do
        fill_in 'Your answer', with: ''
        click_on 'Save edits'

        expect(page).to have_content 'Body can\'t be blank'
      end
    end

  end

  scenario 'Authentificated user try to edit not his answer', js: true do
    sign_in(not_owner)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Edit'
    end
  end
end
