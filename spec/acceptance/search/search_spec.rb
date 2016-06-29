require_relative '../acceptance_helper'

feature 'search and view results', :js do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }
  given!(:comment) { create(:comment_answer) }
  given!(:user) { create(:user) }

  scenario 'all' do
    index
    visit root_path


    click_on 'Search'
    expect(page).to have_content question.title
    expect(page).to have_content answer.body
    expect(page).to have_content comment.body
    expect(page).to have_content user.email

    fill_in 'search_query', with: question.title
    select 'question', from: 'search_type'
    click_on 'Search'
    expect(page).to have_content question.title
    expect(page).not_to have_content answer.body
    expect(page).not_to have_content comment.body
    expect(page).not_to have_content user.email

    fill_in 'search_query', with: answer.body
    select 'answer', from: 'search_type'
    click_on 'Search'
    expect(page).not_to have_content question.title
    expect(page).to have_content answer.body
    expect(page).not_to have_content comment.body
    expect(page).not_to have_content user.email

    fill_in 'search_query', with: comment.body
    select 'comment', from: 'search_type'
    click_on 'Search'
    expect(page).not_to have_content question.title
    expect(page).not_to have_content answer.body
    expect(page).to have_content comment.body
    expect(page).not_to have_content user.email

    fill_in 'search_query', with: user.email
    select 'user', from: 'search_type'
    click_on 'Search'
    expect(page).not_to have_content question.title
    expect(page).not_to have_content answer.body
    expect(page).not_to have_content comment.body
    expect(page).to have_content user.email
  end
end