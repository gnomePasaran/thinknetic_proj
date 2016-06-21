require 'rails_helper'

describe 'Answer API' do
  let!(:question) { create(:question) }
  let!(:answers) { create_pair(:answer, question: question) }
  let!(:comment) { create(:comment_answer, commentable: answer1) }
  let!(:attachment) { create(:attachment_answer, attachable: answer1) }

  let(:access_token) { create(:access_token) }
  let(:answer1) { answers.first }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is invalid access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: 1234
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'questions' do
        before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

        it 'returns status 200' do
          expect(response).to be_success
        end

        it 'returns questions list' do
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
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is invalid access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: 1234
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers/#{answer1.id}", format: :json, access_token: access_token.token }

      context 'answer' do
        it 'returns status 200' do
          expect(response).to be_success
        end

        it 'returns question' do
          response.body
          expect(response.body).to have_json_size(6)
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer1.send(attr.to_sym).to_json).at_path(attr)
          end
        end
      end

      context 'answer should contains' do
        it 'comments' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment should contains #{attr}" do
            expect(response.body).to be_json_eql(answer1.comments.first.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end

        it 'attachments' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        %w(id created_at updated_at).each do |attr|
          it "comment should contains #{attr}" do
            expect(response.body).to be_json_eql(answer1.attachments.first.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end

        it 'attachment object contains filename' do
          expect(response.body).to be_json_eql(answer1.attachments.first.file.filename.to_json).at_path('attachments/0/filename')
        end

        it 'attachment object contains url' do
          expect(response.body).to be_json_eql(answer1.attachments.first.file.url.to_json).at_path('attachments/0/url')
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is invalid access_token' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: 1234
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'creates question with valid attributes' do
        let(:post_answer) do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:answer)
        end

        context 'answer' do
          it 'returns status 201' do
            post_answer
            expect(response.status).to eq 201
          end

          it 'creates new answer' do
            expect { post_answer }.to change(Answer, :count).by(1)
          end
        end
      end

      context 'does not create answer with invalid attributes' do
        let(:post_invalid_answer) do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer)
        end

        context 'answer' do
          it 'returns status 422' do
            post_invalid_answer
            expect(response.status).to eq 422
          end

          it 'creates new answer' do
            expect { post_invalid_answer }.not_to change(Answer, :count)
          end
        end
      end
    end
  end
end
