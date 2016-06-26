FactoryGirl.define do
  factory :question do
    title "MyQuestionTitle"
    body "MyQuestionBody"
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user_id nil
  end
end
