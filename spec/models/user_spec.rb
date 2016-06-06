require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }

  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  let(:auth) { OmniAuth::AuthHash.new(provider: 'Facebook', uid: '123456', info: { email: "test@email.com" }) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user, email: "test@email.com") }

    context 'user already has authorization' do
      it 'returns the user' do
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists' do

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end

        it 'user must have confirmed_at' do
          user = User.find_for_oauth(auth)
          expect(user.confirmed_at).to be_present
        end
      end


      context 'user does not exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'Facebook', uid: '123456', info: { email: 'new@email.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info['email']
        end
        it 'creates authorization for new user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end
        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context 'user has no email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'Facebook', uid: '123456') }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'returns nil' do
          expect(User.find_for_oauth(auth)).to eq nil
        end

        it 'does not creates user' do
          expect { User.find_for_oauth(auth) }.not_to change(User, :count)
        end
      end
    end
  end

  describe '.create_user_from_auth' do
    context 'with email' do
      it 'returns user' do
        expect(User.create_user_from_auth(auth)).to be_a User
      end

      it 'creates user' do
        expect { User.create_user_from_auth(auth) }.to change(User, :count).by(1)
      end

      it 'creates authorization' do
        expect { User.create_user_from_auth(auth) }.to change(Authorization, :count).by(1)
      end

      it 'creates authorization with provider, uid and email', :aggregate_failures do
        authorization = User.create_user_from_auth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
        expect(authorization.user.email).to eq auth.info.email
      end

      it 'skips confirmation' do
        expect(User.create_user_from_auth(auth).confirmed?).to be true
      end
    end

    context 'without email' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123') }

      it 'returns nil' do
        expect(User.find_for_oauth(auth)).to eq nil
      end
    end
  end

  describe '.create_user_from_session' do
    let(:email) { 'test@email.com' }

    context 'with email' do
      it 'returns user' do
        expect(User.create_user_from_session(auth, email)).to be_a User
      end

      it 'creates user' do
        expect { User.create_user_from_session(auth, email) }.to change(User, :count).by(1)
      end

      it 'creates Authorization' do
        expect { User.create_user_from_session(auth, email) }.to change(Authorization, :count).by(1)
      end

      it 'creates Authorization with provider, uid and email' do
        authorization = User.create_user_from_session(auth, email).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
        expect(authorization.user.email).to eq auth.info.email
      end

      it 'does not skips confirmation' do
        expect(User.create_user_from_session(auth, email).confirmed?).to be false
      end
    end

    context 'without email' do
      it 'returns user' do
        expect(User.create_user_from_session(auth, email: nil)).to be_a User
      end

      it 'does not creates user' do
        expect { User.create_user_from_session(auth, email: nil) }.not_to change(User, :count)
      end
    end
  end

  describe '.create_authorizations' do
    it 'creates Authorization' do
      expect { User.create_user_from_auth(auth) }.to change(Authorization, :count).by(1)
    end
  end
end
