require 'rails_helper'

describe 'Answer API' do
  let!(:question) { create(:question) }
  let!(:answers) { create_pair(:answer, question: question) }
  let!(:comment) { create(:comment_answer, commentable: answer1) }
  let!(:attachment) { create(:attachment_answer, attachable: answer1) }

  let(:access_token) { create(:access_token) }
  let(:answer1) { answers.first }

  subject { Answer }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'questions' do
        before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

        it 'returns status 200' do
          expect(response).to be_success
        end

        it 'returns answers list' do
          expect(response.body).to have_json_size(2)
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            answers.each_with_index do |answer, index|
              expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{index}/#{attr}")
            end
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers/#{answer1.id}", format: :json, access_token: access_token.token }

      context 'answer' do
        it 'returns status 200' do
          expect(response).to be_success
        end

        it 'returns answer' do
          response.body
          expect(response.body).to have_json_size(6)
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer1.send(attr.to_sym).to_json).at_path(attr)
          end
        end
      end

      let(:object) { object = answer1 }

      it_behaves_like 'API commentable'
      it_behaves_like 'API attachable'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer1.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'creates question with valid attributes' do
        let(:post_request) do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:answer)
        end

        it_behaves_like 'API creatable valid'
      end

      context 'does not create answer with invalid attributes' do
        let(:post_invalid_request) do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer)
        end

        it_behaves_like 'API creatable invalid'
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end
