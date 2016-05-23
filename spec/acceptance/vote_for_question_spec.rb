require_relative 'acceptance_helper'

feature 'Vote for the question', %q{
  In order to be able to vote for the question
  As an User
  I want to be able to vote for the question
} do

  given(:user) { create(:user) }
  given(:no_author) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authentificated user' do
    before do
      sign_in(user)
      visit question_path question
    end

    scenario 'Non-author of question try to vote' do
      within ".question" do
        expect(page).to have_link 'Vote +'
        click_on 'Vote +'
      end

      expect(page).not_to have_content 'Vote +'
      expect(page).to have_content 'Score: 1'
      expect(page).to have_content 'Cancel'
    end

    scenario 'Author of question try to vote for his question' do
      within ".question" do
        expect(page).not_to have_link 'Vote +'
        expect(page).not_to have_link 'Cancel'
        expect(page).not_to have_link 'Vote -'
      end
    end

    scenario 'Author of question try to mark other answer' do
    end

    scenario 'The best answer should be first' do
    end
  end

  scenario 'Non-authentificated user try to vote ' do
    sign_in(no_author)
    visit question_path question

    within '.question' do
      expect(page).not_to have_content 'Vote +'
      expect(page).not_to have_link 'Cancel'
      expect(page).not_to have_link 'Vote -'
    end
  end
end
