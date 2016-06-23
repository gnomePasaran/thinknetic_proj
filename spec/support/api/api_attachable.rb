shared_examples_for 'API attachable' do
  it 'attachments' do
    expect(response.body).to have_json_size(1).at_path('attachments')
  end

  %w(id created_at updated_at).each do |attr|
    it "comment should contains #{attr}" do
      expect(response.body).to be_json_eql(object.attachments.first.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
    end
  end

  it 'attachment object contains filename' do
    expect(response.body).to be_json_eql(object.attachments.first.file.filename.to_json).at_path('attachments/0/filename')
  end

  it 'attachment object contains url' do
    expect(response.body).to be_json_eql(object.attachments.first.file.url.to_json).at_path('attachments/0/url')
  end
end
