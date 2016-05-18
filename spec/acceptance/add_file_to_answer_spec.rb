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

  scenario 'User attach many files when answer question', js: true do
    fill_in 'Your answer', with: 'Test answer'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'add attach'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end