require 'rails_helper'

feature 'Observe question', %q{
  In order to observe question
  As an user
  I want to be able to observe questions
} do

  scenario 'User observe question' do
    question = create(:question)
    visit questions_path

    expect(page).to have_content question.title
  end
end