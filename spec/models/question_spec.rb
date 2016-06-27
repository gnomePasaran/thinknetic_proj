require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should validate_presence_of :user_id }
  it { should belong_to(:user) }

  it { should have_many(:answers).dependent(:destroy).order(is_best: :desc, created_at: :asc) }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }

  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should have_many(:subscriptions).dependent(:destroy) }

  context 'subscriptions' do
    let(:question) { build(:question) }

    it 'receives subscribe_user after commit on create' do
      expect(question).to receive(:subscribe_user)
      question.save
    end

    it 'creates subscription' do
      expect { question.save }.to change(Subscription, :count).by(1)
    end
  end
end
