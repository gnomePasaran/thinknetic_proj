require_relative '../acceptance_helper'

feature 'Vote for the question', %q{
  In order to be able to vote for the question
  As an User
  I want to be able to vote for the question
} do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Non-author of question ' do
    before do
      sign_in(non_author)
      visit question_path question
    end

    scenario 'try to vote', js: true do
      within ".question" do
        expect(page).to have_link 'Vote +'
        click_on 'Vote +'
      end
      expect(page).not_to have_content 'Vote +'
      expect(page).to have_content 'Score: 1'
      expect(page).to have_content 'Cancel'

      within ".question" do
        expect(page).to have_link 'Cancel'
        click_on 'Cancel'
      end
      expect(page).not_to have_content 'Cancel'
      expect(page).to have_content 'Score: 0'
      expect(page).to have_content 'Vote +'

      within ".question" do
        expect(page).to have_link 'Vote -'
        click_on 'Vote -'
      end
      expect(page).not_to have_content 'Vote -'
      expect(page).to have_content 'Score: -1'
      expect(page).to have_content 'Cancel'
    end
  end

  describe 'Author of question' do
    before do
      sign_in(author)
      visit question_path question
    end

    scenario 'try to vote for his question', js: true do
      within ".question" do
        expect(page).to have_content 'Score:'
        expect(page).not_to have_link 'Vote +'
        expect(page).not_to have_link 'Cancel'
        expect(page).not_to have_link 'Vote -'
      end
    end
  end

  scenario 'Non-authentificated user try to vote', js: true do
    visit question_path question

    within '.question' do
      expect(page).not_to have_content 'Vote +'
      expect(page).not_to have_link 'Cancel'
      expect(page).not_to have_link 'Vote -'
    end
  end
end
