require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:create_subscription) { post :create, id: question, format: :json }
  let(:destroy_subscription) { delete :destroy, id: question, format: :json }

  describe 'POST #create' do
    context 'as user', :users, :auth do
      sign_in_user
      it 'returns create status' do
        create_subscription
        expect(response).to have_http_status(:created)
      end

      it 'saves a new subscription in the database' do
         expect { create_subscription }.to change(Subscription, :count).by(1)
      end
    end

    context 'as quest' do
      it 'returns create status' do
        create_subscription
        expect(response).to have_http_status(:unauthorized)
      end

      it 'saves a new subscription in the database' do
         expect { create_subscription }.not_to change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as user', :users, :auth do
      sign_in_user

      before do
        create(:subscription, user: @user, question: question)
      end

      it 'returns destroy status' do
        destroy_subscription
        expect(response).to have_http_status(:success)
      end

      it 'deletes a new subscription in the database' do
         expect { destroy_subscription }.to change(Subscription, :count).by(-1)
      end
    end


    context 'as quest' do
      it 'returns create status' do
        destroy_subscription
        expect(response).to have_http_status(:unauthorized)
      end

      it 'saves a new subscription in the database' do
         expect { destroy_subscription }.not_to change(Subscription, :count)
      end
    end
  end
end