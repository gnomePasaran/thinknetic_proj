require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:not_author) { create(:user) }
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question) }
  let(:owner_answer) { create(:answer, question: question, user: @user) }
  let(:not_owner_answer) { create(:answer, question: not_owner_question, user: not_author) }
  let(:not_owner_question) { create(:question, user: not_author) }
  let(:vote_1) { create(:vote_answer, votable: not_owner_answer, user: user, score: 1) }

  let(:vote_params) { { id: not_owner_answer, question_id: question } }
  let(:votable) { not_owner_answer }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'saves a new answer in the database with user id' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid attributes' do
      it 'assigns a requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, id: owner_answer, answer: { question_id: question, body: 'new_body' }, question_id: question, format: :js
        owner_answer.reload
        question.answers << owner_answer
        expect(owner_answer.question_id).to eq question.id
        expect(owner_answer.body).to eq 'new_body'
      end

      it 'render update question' do
        patch :update, id: owner_answer, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, id: owner_answer, answer: { question_id: 1, body: nil }, question_id: question, format: :js }
      it 'does not change answer attributes' do
        answer.reload
        expect(owner_answer.question_id).to eq question.id
        expect(owner_answer.body).to eq 'MyAnswerBody'
      end

      it 're-renders update' do
        expect(response).to render_template :update
      end
    end

    context 'with valid attributes as non-author' do
      it 'not assigns a requested answer to @answer' do
        patch :update, id: not_owner_answer, answer: attributes_for(:answer), question_id: question, format: :js
        expect(assigns(:not_owner_answer)).not_to eq not_owner_answer
      end

      it 'redirects to the update answer' do
        patch :update, id: not_owner_answer, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { owner_answer }

    context 'owner deletes the answer' do
      it 'deletes answer' do
        expect { delete :destroy, id: owner_answer, question_id: question, format: :js }.to change(@user.answers, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, id: answer, question_id: question , format: :js
        expect(response.status).to eq 403
      end
    end

    context 'not owner deletes the answer' do
      it 'deletes answer' do
        answer
        expect { delete :destroy, id: answer, question_id: question, format: :js }.not_to change(Answer, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response.status).to eq 403
      end
    end
  end

  describe 'GET #toggle_best' do
    sign_in_user
    context 'owner marks the best answer' do
      before do
        get :toggle_best, id: owner_answer, question_id: question
      end
      it 'marks answer' do
        expect{ owner_answer.reload }.to change{ owner_answer.is_best }.from(false).to(true)
      end

      it 'renders new order of question' do
        expect(response).to redirect_to question
      end
    end

    context 'owner marks not his answer' do
      it 'marks answer' do
        sign_in(not_author)
        get :toggle_best, id: not_owner_answer, question_id: not_owner_question
        expect{ not_owner_answer.reload }.to change{ not_owner_answer.is_best }.from(false).to(true)
      end
    end

    context 'not owner of question try to toggle best' do
      before do
        not_owner_question
        get :toggle_best, id: not_owner_answer, question_id: not_owner_question
      end

      it 'marks answer' do
        expect{ not_owner_answer.reload }.not_to change{ owner_answer.is_best }
      end

      it 'renders new order of question' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #vote' do
    it_behaves_like 'votable'
  end
end
