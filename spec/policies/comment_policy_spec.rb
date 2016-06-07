require 'rails_helper'

RSpec.describe CommentPolicy do

  let(:user) { create(:user) }

  subject { described_class }

  permissions :create? do
    it { should_not permit(nil, Comment) }
    it { should permit(user, Comment) }
  end
end
