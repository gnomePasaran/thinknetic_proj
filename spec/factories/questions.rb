FactoryGirl.define do
  factory :question do
    title "MyQuestionTitle"
    body "MyQuestionBody"
    user_id 1
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user_id nil
  end
end
