require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate question
  As an question's athor
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User attach file when ask the question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test test'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User attach many files when ask the question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test test'

    within '.nested-fields:nth-child(1)' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'add attach'

    within '.nested-fields:nth-child(2)' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
  end
end