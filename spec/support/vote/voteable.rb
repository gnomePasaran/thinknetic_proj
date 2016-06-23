shared_examples 'votable' do
  let(:vote_up) { post :vote_up,  vote_params }
  let(:vote_down) { post :vote_down,  vote_params }
  let(:vote_cancel) { post :vote_cancel,  vote_params }

  sign_in_user
  context 'user likes the question' do

    before do
      votable
      sign_in(user)
    end

    it 'likes question' do
      expect { vote_up }.to change{ votable.get_score }.from(0).to(1)
    end

    it 'unlikes question' do
      expect { vote_down }.to change{ votable.get_score }.from(0).to(-1)
    end

    it 'cancel voting for question' do
      vote_1
      expect { vote_cancel }.to change{ votable.get_score }.from(1).to(0)
    end
  end

  context 'Athor of the question try to' do

    before do
      votable
      sign_in(not_author)
    end

    it 'likes question' do
      expect { vote_up }.not_to change{ votable.get_score }
    end

    it 'unlikes question' do
      expect { vote_down }.not_to change{ votable.get_score }
    end

    it 'cancel voting for question' do
      vote_1
      expect { vote_cancel }.not_to change{ votable.get_score }
    end

    it 'render question view' do
      vote_up
      expect(response.status).to eq 302
    end
  end
end