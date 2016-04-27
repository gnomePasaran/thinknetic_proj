require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'should has many answers' do
    question = FactoryGirl.create(:question)
    answer_1 = FactoryGirl.create(:answer)
    answer_2 = FactoryGirl.create(:answer)
    question.answers << answer_1
    question.answers << answer_2

    expect(question.answers.count).to eq 2
  end
end
