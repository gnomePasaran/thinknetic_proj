require 'rails_helper'

RSpec.describe CommentPolicy do

  let(:guest) { nil }
  let(:user) { create(:user) }

  subject { described_class }

  permissions :create? do
    it { should_not permit(guest, Comment) }
    it { should permit(user, Comment) }
  end
end
