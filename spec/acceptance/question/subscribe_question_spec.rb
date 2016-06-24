require_relative '../acceptance_helper'

feature 'Subscribe to a question', %q{
  In order to subscribe question
  As an authenticated user
  I want to be able to subscribe to a question
} do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:owner_question) { create(:question, user: user) }

  describe 'Authenticated' do
    background do
      sign_in user
    end

    scenario 'user try to subscribe to a question', js: true do
      visit question_path(question)

      within '#subscription-links' do
        expect(page).to have_link 'subscribe'
        expect(page).not_to have_link 'unsubscribe'
        click_on 'subscribe'

        expect(page).not_to have_link ' subscribe'
        expect(page).to have_link 'unsubscribe'

        click_on 'unsubscribe'
        expect(page).to have_link 'subscribe'
        expect(page).not_to have_link 'unsubscribe'
      end
    end

    scenario 'athor should be subscribed to his question' do
      visit question_path(owner_question)

      within '#subscription-links' do
        expect(page).not_to have_link ' subscribe'
        expect(page).to have_link 'unsubscribe'
      end
    end
  end

  scenario 'Unauthenticated user try to subscribe' do
    visit question_path(question)

    expect(page).not_to have_link 'subscribe'
  end

end