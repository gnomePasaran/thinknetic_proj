FactoryGirl.define do
  factory :vote do
    user_id 1

    factory :vote_question do
      association :votable, factory: :question
    end
    factory :vote_answer do
      association :votable, factory: :answer
    end

    score 0
  end
end
