require 'rails_helper'

feature 'Delete answer', %q{
  In order to be able to delete answer
  As an User
  I want to be able to delete answer
} do

  given(:owner) { create(:user) }
  given(:not_owner) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: owner) }

  scenario 'Signed in user try to delete his answer' do
    sign_in(owner)

    visit questions_path
    expect(page).to have_content question.title

    click_on question.title
    click_on 'Delete answer'

    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content answer.body
  end

  scenario 'Signed in user try to delete not his answer' do
    sign_in(not_owner)

    visit questions_path
    click_on question.title
    expect(page).not_to have_content 'Delete answer'
  end

  scenario 'Non-signed in user try to delete answer' do
    visit questions_path

    expect(page).to have_content question.title
    click_on question.title

    expect(page).not_to have_content 'Delete answer'
  end
end
