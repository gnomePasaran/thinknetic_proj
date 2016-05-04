require 'rails_helper'

feature 'Answer question', %q{
  In order to answer question
  As an user
  I want to be able to answer the question
} do

  scenario 'User answer the question' do
    question = create(:question)
    visit questions_path
    click_on 'To answer'

    visit new_question_answer_path(question)
    fill_in 'Body', with: 'Test answer'
    click_on 'Create'

    expect(current_path).to eq question_path question
  end
end