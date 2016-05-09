require_relative 'acceptance_helper'

feature 'Observe question', %q{
  In order to observe question
  As an user
  I want to be able to observe questions
} do

  scenario 'User observe question' do
    questions = create_pair(:question)
    visit questions_path

    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
  end
end