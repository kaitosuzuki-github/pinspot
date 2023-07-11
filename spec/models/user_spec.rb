require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#follow' do
    let(:user) { create(:user) }
    let(:follow_user) { create(:user) }

    it 'userに関連するrelationshipを作成すること' do
      expect { user.follow(follow_user.id) }.to change { user.relationships.count }.by(1)
    end
  end
end
