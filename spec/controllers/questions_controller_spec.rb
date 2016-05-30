require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:not_author) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:owner_question) { create(:question, user: @user) }
  let(:not_owner_question) { create(:question, user: not_author) }
  let(:answer) { create(:answer, question: owner_question, user: not_author) }
  let(:vote_1) { create(:vote_question, votable: owner_question, user: not_author, score: 1) }


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

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
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
    before { owner_question }

    context 'with valid attributes as author' do
      it 'assigns a requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: owner_question, question: { title: 'new_title', body: 'new_body' }, format: :js
        owner_question.reload
        expect(owner_question.title).to eq 'new_title'
        expect(owner_question.body).to eq 'new_body'
      end

      it 'redirects to the update question' do
        patch :update, id: owner_question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes as author' do
      before { patch :update, id: question, question: { title: 'new_title', body: nil }, format: :js }
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyQuestionTitle'
        expect(question.body).to eq 'MyQuestionBody'
      end

      it 're-renders edit view' do
        patch :update, id: owner_question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'with valid attributes as non-author' do
      it 'not assigns a requested question to @question' do
        patch :update, id: not_owner_question, question: attributes_for(:question), format: :js
        expect(assigns(:not_owner_question)).not_to eq not_owner_question
      end

      it 'redirects to the update question' do
        patch :update, id: not_owner_question, question: attributes_for(:question), format: :js
        expect(response).to redirect_to not_owner_question
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
        expect(response).to redirect_to questions_path
      end
    end

    context 'non-owner delete the question' do
      it 'not able to deletes question' do
        expect { delete :destroy, id: not_owner_question }.not_to change(@user.questions, :count)
      end

      it 'redirects to index view' do
        delete :destroy, id: not_owner_question
        expect(response).to redirect_to question_path
      end
    end
  end

  describe 'POST #vote' do
    sign_in_user

    context 'user likes the question' do

      before do
        owner_question
        sign_in(not_author)
      end

      it 'likes question' do
        expect { post :vote_up, id: owner_question }
            .to change{ owner_question.get_score }.from(0).to(1)
      end

      it 'unlikes question' do
        expect { post :vote_down, id: owner_question }
            .to change{ owner_question.get_score }.from(0).to(-1)
      end

      it 'cancel voting for question' do
        vote_1
        expect { post :vote_cancel, id: owner_question }
            .to change{ owner_question.get_score }.from(1).to(0)
      end
    end

    context 'Athor of the question try to' do

      before do
        question
        sign_in(user)
      end

      it 'likes question' do
        expect { post :vote_up, id: question }
            .not_to change{ question.get_score }
      end

      it 'unlikes question' do
        expect { post :vote_down, id: question }
            .not_to change{ question.get_score }
      end

      it 'cancel voting for question' do
        vote_1
        expect { post :vote_cancel, id: question }
            .not_to change{ question.get_score }
      end

      it 'render question view' do
        post :vote_up, id: question
        expect(response.status).to eq 403
      end
    end
  end
end
