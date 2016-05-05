require 'rails_helper'

feature 'Observe answer', %q{
  In order to observe annswer
  As an user
  I want to be able to observe answer
} do

  scenario 'User observe answer' do
    question = create(:question)
    answers = create_pair(:answer, question: question)

    visit questions_path
    click_on question.title

    expect(current_path).to eq question_path question
    expect(page).to have_content question.body
    expect(page).to have_content answers.first.body
    expect(page).to have_content answers.last.body
  end
end