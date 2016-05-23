require_relative 'acceptance_helper'

feature 'Edit files to question', %q{
  In order to illustrate answer
  As an question's athor
  I want to be able to edit files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User edit attached files when answer question', js: true do
    within '.question' do
      click_on 'Edit question'
      click_on 'add attach'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save edits'
    end

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'

    within '.question' do
      click_on 'Edit question'
      click_on 'remove attach'
      click_on 'add attach'
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Save edits'
    end
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end