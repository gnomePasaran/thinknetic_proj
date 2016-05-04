require 'rails_helper'

feature 'Create question', %q{
  In order to observ question
  As an user
  I want to be able to observe question
} do


  scenario 'User observe question' do
    question = create(:question)
    visit questions_path

    expect(page).to have_content question.title #'Your question successfully created.'
  end
end