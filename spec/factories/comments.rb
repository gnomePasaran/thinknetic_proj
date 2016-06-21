FactoryGirl.define do
  factory :comment do
    body "CommentBody"
    user_id 1

    factory :comment_question do
      association :commentable, factory: :question
    end
    factory :comment_answer do
      association :commentable, factory: :answer
    end
  end
end
