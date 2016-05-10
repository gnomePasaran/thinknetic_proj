require_relative 'acceptance_helper'

feature 'Mark best answer', %q{
  In order to be able to mark answer
  As an User
  I want to be able to mark answer
} do

  given(:user) { create(:user) }
  given(:no_author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_pair(:answer, question: question, user: user) }

  describe 'Authentificated user' do
    before do
      sign_in(user)
      visit question_path question
    end

    scenario 'Author of question try to mark best answer' do
      within "#answer-#{answers.first.id}" do #id of the answer div
        expect(page).to have_link 'Mark best'
        click_on 'Mark best'
      end

      expect(page).to have_content 'THE BEST'
      expect(page).to have_content 'Unmark best'
    end

    scenario 'Author of question try to unmark best answer' do
      within "#answer-#{answers.first.id}" do
        click_on 'Mark best'
      end
      within "#answer-#{answers.first.id}" do
        expect(page).to have_content 'Unmark best'
        click_on 'Unmark best'
      end

      expect(page).not_to have_content 'THE BEST'
      expect(page).not_to have_content 'Unmark best'
    end

    scenario 'Author of question try to mark other answer' do
      within "#answer-#{answers.first.id}" do
        click_on 'Mark best'
      end
      within "#answer-#{answers.last.id}" do
        expect(page).to have_content 'Mark best'
        click_on 'Mark best'
      end

      within "#answer-#{answers.first.id}" do
        expect(page).not_to have_content 'Unmark best'
      end 
      within "#answer-#{answers.last.id}" do 
        expect(page).to have_content 'THE BEST'
      end  
    end
  end

  scenario 'Non-author of question try to mark best answer' do
    sign_in(no_author)
    visit question_path question

    within '.answers' do
      expect(page).not_to have_content 'Mark best'
    end
  end
end
