require_relative '../acceptance_helper'

feature 'Vote for the answer', %q{
  In order to be able to vote for the answer
  As an User
  I want to be able to vote for the answer
} do

  given!(:author) { create(:user) }
  given!(:non_author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Non-author of answer ' do
    before do
      sign_in(non_author)
      visit question_path question
    end

    scenario 'try to vote', js: true do
      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Vote +'
        click_on 'Vote +'
      end
      within "#answer-#{answer.id}" do
        expect(page).not_to have_content 'Vote +'
        expect(page).to have_content 'Score: 1'
        expect(page).to have_content 'Cancel'
      end

      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Cancel'
        click_on 'Cancel'
      end
      within "#answer-#{answer.id}" do
        expect(page).not_to have_content 'Cancel'
        expect(page).to have_content 'Score: 0'
        expect(page).to have_content 'Vote +'
      end

      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Vote -'
        click_on 'Vote -'
      end
      within "#answer-#{answer.id}" do
        expect(page).not_to have_content 'Vote -'
        expect(page).to have_content 'Score: -1'
        expect(page).to have_content 'Cancel'
      end
    end
  end

  describe 'Author of question' do
    before do
      sign_in(author)
      visit question_path question
    end

    scenario 'try to vote for his question', js: true do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Score:'
        expect(page).not_to have_link 'Vote +'
        expect(page).not_to have_link 'Cancel'
        expect(page).not_to have_link 'Vote -'
      end
    end
  end

  scenario 'Non-authentificated user try to vote', js: true do
    visit question_path question

    within "#answer-#{answer.id}" do
      expect(page).not_to have_content 'Vote +'
      expect(page).not_to have_link 'Cancel'
      expect(page).not_to have_link 'Vote -'
    end
  end
end
