require_relative '../acceptance_helper'

feature 'Delete question', %q{
  In order to be able to delete question
  As an User
  I want to be able to delete question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Signed in user try to delete his question' do
    sign_in(user)

    visit questions_path
    expect(page).to have_content question.title

    click_on question.title
    click_on 'Delete question'

    expect(current_path).to eq questions_path
    expect(page).not_to have_content question.title
  end

  given(:not_owner) { create(:user) }

  scenario 'Signed in user try to delete not his question' do
    sign_in(not_owner)

    visit questions_path
    click_on question.title
    expect(page).not_to have_content 'Delete question'
  end

  scenario 'Non-signed in user try to delete question' do
    visit questions_path

    expect(page).to have_content question.title
    click_on question.title

    expect(page).not_to have_content 'Delete question'
  end
end
