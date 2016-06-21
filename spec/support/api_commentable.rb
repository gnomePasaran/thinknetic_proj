shared_examples_for 'API commentable' do
  context 'answer should contains' do
    it 'comments' do
      expect(response.body).to have_json_size(1).at_path('comments')
    end

    %w(id body created_at updated_at).each do |attr|
      it "comment should contains #{attr}" do
        expect(response.body).to be_json_eql(object.comments.first.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
      end
    end
  end
end