require_relative 'acceptance_helper'

feature 'Mark best answer', %q{
  In order to be able to mark answer
  As an User
  I want to be able to mark answer
} do

  given(:user) { create(:user) }
  given(:no_author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answers) { create_pair(:answer, question: qusetion, user: user) }

  describe 'Authentificated user' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'Author of question try to mark best answer' do
      within '.answer' do
        expect(page).to have_content 'Mark best'
        click_on 'Mark best'

        expect(page).to have_content 'THE BEST'
        expect(page).to have_content 'Unmark best'
      end
    end

    scenario 'Author of question try to unmark best answer' do
      within '.answer' do
        expect(page).to have_content 'Unmark best'
        click_on 'Mark best'

        expect(page).not_to have_content 'THE BEST'
        expect(page).not_to have_content 'Unmark best'
      end
    end
  end

  scenario 'Non-author of question try to mark best answer' do
    sign_in(user)
    visit questions_path

    within '.answer' do
      expect(page).not_to have_content 'Mark best'
    end
  end
end
