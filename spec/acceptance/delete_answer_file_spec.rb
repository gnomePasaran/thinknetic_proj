require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to be able to delete answer
  As an User
  I want to be able to delete answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user,  question: question) }
  given!(:attachment) { create(:attachment_answer, attachable: answer) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User attach file when ask the question', js: true do
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'

    click_on 'Edit answer'
    within '.answers' do
      click_on 'remove attach'
      click_on 'Save edits'
    end

    expect(page).not_to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
