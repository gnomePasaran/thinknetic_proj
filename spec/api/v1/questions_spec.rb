require 'rails_helper'

describe 'Question API' do
  let(:access_token) { create(:access_token) }
  let!(:questions) { create_pair(:question) }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is invalid access_token' do
        get '/api/v1/questions', format: :json, access_token: 1234
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'questions' do
        let!(:answer) { create(:answer, question: questions.first) }

        before { get '/api/v1/questions', format: :json, access_token: access_token.token }

        it 'returns status 200' do
          expect(response).to be_success
        end

        it 'returns questions list' do
          expect(response.body).to have_json_size(2)
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
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/1', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is invalid access_token' do
        get '/api/v1/questions/1', format: :json, access_token: 1234
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:question) { create(:question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      context 'question' do
        it 'returns status 200' do
          expect(response).to be_success
        end

        it 'returns question' do
          expect(response.body).to have_json_size(7)
        end

        %w(id title body created_at updated_at).each do |attr|
          it "question object contains #{attr}" do
            p response.body
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end

        it 'question object contains short_title' do
          expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("short_title")
        end
      end

      context 'question should contains' do
        let!(:comments) { create_pair(:comment_question, commentable: question) }

        it 'comments' do
          expect(response.body).to be_json_eql(question.comments.to_json)
        end

        it "comment should contains #{attr}" do
          expect(response.body).to 
            be_json_eql(question.comments.first.send(attr.to_sym).to_json).at_path("comments/#{attr}")
        end
      end
    end
  end
end
