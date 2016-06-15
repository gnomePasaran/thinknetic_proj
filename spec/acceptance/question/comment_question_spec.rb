require_relative '../acceptance_helper'

feature 'Add comment', %q{
  In order to comment question
  As an user
  I want to be able to comment the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authentificated user to comment' do
    background do
      sign_in(user)
      visit question_path question
    end

    scenario 'the question with valid', js: true do
      within '.question' do
        expect(page).to have_content 'Create comment'
        click_on 'Create comment'
      end
      within '.question-comments' do
        fill_in 'Your comment', with: 'Question comment'
        click_on 'Create comment'
      end

      within '.question' do
        expect(page).to have_content 'Question comment'
      end
    end

    scenario 'the answer with valid', js: true do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Create comment'
        click_on 'Create comment'
      end
      within ".answer-comments" do
        fill_in 'Your comment', with: 'Question comment'
        click_on 'Create comment'
      end

      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Question comment'
      end
    end
  end

  scenario 'Non-authentificated user try to comment', js: true do
    visit question_path question
    expect(page).not_to have_content 'Create comment'
  end
end
