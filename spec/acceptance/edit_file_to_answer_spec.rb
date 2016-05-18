require_relative 'acceptance_helper'

feature 'Edit files to answer', %q{
  In order to illustrate answer
  As an answer's athor
  I want to be able to edit files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }


  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User edit attached files when answer question', js: true do
    within "#answer-#{answer.id}" do
      click_on 'Edit answer'
      click_on 'add attach'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save edits'

      # save_and_open_page
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    within "#answer-#{answer.id}" do
      click_on 'Edit answer'
      click_on 'remove attach'
      click_on 'add attach'
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Save edits'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end