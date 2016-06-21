require 'rails_helper'

describe 'Question API' do
  let!(:access_token) { create(:access_token) }
  let!(:questions) { create_pair(:question) }
  let!(:question1) { create(:question) }
  let!(:comment) { create(:comment_question, commentable: question1) }
  let!(:attachment) { create(:attachment_question, attachable: question1) }

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

      context 'question should contains comments' do
        it 'comments' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment should contains #{attr}" do
            expect(response.body).to be_json_eql(question1.comments.first.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'question should contains attachments' do
        it 'attachments' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        %w(id created_at updated_at).each do |attr|
          it "comment should contains #{attr}" do
            expect(response.body).to be_json_eql(question1.attachments.first.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end

        it 'attachment object contains filename' do
          expect(response.body).to be_json_eql(question1.attachments.first.file.filename.to_json).at_path('attachments/0/filename')
        end

        it 'attachment object contains filename' do
          expect(response.body).to be_json_eql(question1.attachments.first.file.url.to_json).at_path('attachments/0/url')
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is invalid access_token' do
        post '/api/v1/questions', format: :json, access_token: 1234
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'creates question with valid attributes' do
        let(:post_question) do
          post "/api/v1/questions", format: :json, access_token: access_token.token, question: attributes_for(:question)
        end

        context 'question' do
          it 'returns status 201' do
            post_question
            expect(response.status).to eq 201
          end

          it 'creates new question' do
            expect { post_question }.to change(Question, :count).by(1)
          end
        end
      end

      context 'does not create question with invalid attributes' do
        let(:post_invalid_question) do
          post "/api/v1/questions", format: :json, access_token: access_token.token, question: attributes_for(:invalid_question)
        end

        context 'question' do
          it 'returns status 422' do
            post_invalid_question
            expect(response.status).to eq 422
          end

          it 'creates new question' do
            expect { post_invalid_question }.not_to change(Question, :count)
          end
        end
      end
    end
  end
end
