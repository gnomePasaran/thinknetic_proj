require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:owner_answer) { create(:answer, question: question, user: @user) }

  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question }

    it 'assigns a new question to @question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: answer, question_id: question }

    it 'assigns a requested question to @question' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

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
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, id: answer, answer: { question_id: question, body: 'new_body' }, question_id: question
        answer.reload
        question.answers << answer
        expect(answer.question_id).to eq question.id
        expect(answer.body).to eq 'new_body'
      end

      it 'redirects to the show question' do
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      before { patch :update, id: answer, answer: { question_id: 1, body: nil }, question_id: question }
      it 'does not change answer attributes' do
        answer.reload
        expect(answer.question_id).to eq 1
        expect(answer.body).to eq 'MyAnswerBody'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { owner_answer }

    context 'owner delete the answer' do
      it 'deletes answer' do
        expect { delete :destroy, id: owner_answer, question_id: question }.to change(@user.answers, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'not owner delete the answer' do
      it 'deletes answer' do
        answer
        expect { delete :destroy, id: answer, question_id: question }.not_to change(Answer, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
