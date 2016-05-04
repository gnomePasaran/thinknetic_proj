require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:owner_question) { create(:question, user: @user) }

  describe 'GET #index' do
    let(:questions) { create_pair(:question) }
    before { get :index }

    it 'populates an arrau of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns a requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns a requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      it 'does not save a new question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid attributes' do
      it 'assigns a requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new_title', body: 'new_body' }
        question.reload
        expect(question.title).to eq 'new_title'
        expect(question.body).to eq 'new_body'
      end

      it 'redirects to the update question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to :question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, id: question, question: { title: 'new_title', body: nil } }
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { owner_question }

    context 'owner delete the question' do
      it 'deletes question' do
        expect { delete :destroy, id: owner_question }.to change(@user.questions, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, id: owner_question
        expect(response).to redirect_to question_path
      end
    end

    context 'not owner delete the question' do
      it 'deletes question' do
        question
        expect { delete :destroy, id: question }.not_to change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to question_path
      end
    end
  end
end
