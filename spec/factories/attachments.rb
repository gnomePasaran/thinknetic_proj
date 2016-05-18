FactoryGirl.define do
  factory :attachment do
  file { Rack::Test::UploadedFile.new("#{Rails.root}/spec/spec_helper.rb") }
    factory :attachment_question do
      association :attachable, factory: :question
    end
    factory :attachment_answer do
      association :attachable, factory: :answer
    end
  end
end
