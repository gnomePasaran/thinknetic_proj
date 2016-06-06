require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of(:uid).scoped_to(:provider) }

  let!(:authorization) { create(:authorization, provider: 'facebook', uid: 123) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: 123) }

  describe '.find_for_oauth' do
    it 'returns authorization' do
      expect(Authorization.find_for_oauth(auth)).to eq authorization
    end
  end
end
