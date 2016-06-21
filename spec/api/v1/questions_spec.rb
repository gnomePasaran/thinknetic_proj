require 'rails_helper'

describe 'Question API' do
  let!(:access_token) { create(:access_token) }
  let!(:questions) { create_pair(:question) }
  let!(:question1) { create(:question) }
  let!(:comment) { create(:comment_question, commentable: question1) }
  let!(:attachment) { create(:attachment_question, attachable: question1) }

  subject { Question }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'questions' do
        let!(:answer) { create(:answer, question: questions.first) }

        before { get '/api/v1/questions', format: :json, access_token: access_token.token }

        it 'returns status 200' do
          expect(response).to be_success
        end

        it 'returns questions list' do
          expect(response.body).to have_json_size(3)
        end

        %w(id title body created_at updated_at).each do |attr|
          it "question object contains #{attr}" do
            questions.each_with_index do |question, index|
              expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{index}/#{attr}")
            end
          end
        end

        it 'question object contains short_title' do
          expect(response.body).to be_json_eql(questions.first.title.truncate(10).to_json).at_path("0/short_title")
        end

        context 'answers' do
          it 'included in question object' do
            expect(response.body).to have_json_size(1).at_path("0/answers")
          end

          %w(id body created_at updated_at).each do |attr|
            it "contains #{attr}" do
              expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
            end
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question1.id}", format: :json, access_token: access_token.token }

      context 'question' do
        it 'returns status 200' do
          expect(response).to be_success
        end

        it 'returns question' do
          expect(response.body).to have_json_size(9)
        end

        %w(id title body created_at updated_at).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(question1.send(attr.to_sym).to_json).at_path(attr)
          end
        end

        it 'question object contains short_title' do
          expect(response.body).to be_json_eql(question1.title.truncate(10).to_json).at_path('short_title')
        end
      end

      let(:object) { object = question1 }

      it_behaves_like 'API commentable'
      it_behaves_like 'API attachable'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question1.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'creates question with valid attributes' do
        let(:post_request) do
          post "/api/v1/questions", format: :json, access_token: access_token.token, question: attributes_for(:question)
        end

        it_behaves_like 'API creatable valid'
      end

      context 'does not create question with invalid attributes' do
        let(:post_invalid_request) do
          post "/api/v1/questions", format: :json, access_token: access_token.token, question: attributes_for(:invalid_question)
        end

        it_behaves_like 'API creatable invalid'
      end
    end

    def do_request(options = {})
      post "/api/v1/questions", { format: :json }.merge(options)
    end
  end
end
