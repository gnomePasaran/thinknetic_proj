require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :body }

  it 'should belongs to the one question' do
    answer = FactoryGirl.create(:answer)
    question = FactoryGirl.create(:question)
    question.answers << answer

    expect(answer.question).to eq question
  end
end
