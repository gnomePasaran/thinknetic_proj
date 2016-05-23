require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :user_id }
  it { should belong_to(:user) }

  it { should belong_to(:votable) }

  it { should validate_presence_of :score }
  it do
    should define_enum_for(:score)
      .with([:like, :neutral, :dislike])
  end
end
