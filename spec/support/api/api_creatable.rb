shared_examples_for 'API creatable valid' do
  context 'question' do
    it 'returns status 201' do
      post_request
      expect(response.status).to eq 201
    end

    it 'creates new question' do
      expect { post_request }.to change(subject, :count).by(1)
    end
  end
end

shared_examples_for 'API creatable invalid' do
  context 'question' do
    it 'returns status 422' do
      post_invalid_request
      expect(response.status).to eq 422
    end

    it 'creates new question' do
      expect { post_invalid_request }.not_to change(subject, :count)
    end
  end
end
