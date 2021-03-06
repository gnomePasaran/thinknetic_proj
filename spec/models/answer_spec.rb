require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :question_id }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  it { should validate_presence_of :user_id }
  it { should belong_to(:user) }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }

  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  describe 'toggle is_best' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    it 'toggles' do
      answer = create(:answer, question: question)
      expect { answer.toggle_best }.to change { answer.reload.is_best }.from(false).to(true)
    end

    it 'untoggles' do
      answer = create(:answer, question: question, is_best: true)
      expect { answer.toggle_best }.to change { answer.reload.is_best }.from(true).to(false)
    end

    it 'toggles new answer' do
      answer = build(:answer, question: question)
      expect { answer.toggle_best }.to change { answer.is_best }.from(false).to(true)
    end

    it 'untoggles new answer' do
      answer = build(:answer, question: question, is_best: true)
      expect { answer.toggle_best }.to change { answer.is_best }.from(true).to(false)
    end
  end

  describe '#notify_subscribers' do
    let!(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }

    it 'run notification job after creating answer' do
      expect(QuestionNotificationJob).to receive(:perform_later)
      answer.run_callbacks(:commit)
    end
  end
end
