require_relative 'acceptance_helper'

feature 'Delete files to question', %q{
  In order to illustrate question
  As an question's athor
  I want to be able to delete attached files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment_question, attachable: question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User attach file when ask the question', js: true do
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'

    click_on 'Edit question'
    within '.question' do
      click_on 'remove attach'
    end
    click_on 'Save edits'

    expect(page).not_to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end