require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate answer
  As an answer's athor
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User attach file when ask the answer', js: true  do
    fill_in 'Your answer', with: 'Test answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end