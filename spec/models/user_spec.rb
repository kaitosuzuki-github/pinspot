require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:follow_user) { create(:user) }

  describe '#follow' do
    it 'userに関連するrelationshipのデータを作成すること' do
      expect { user.follow(follow_user.id) }.to change { user.relationships.count }.by(1)
    end
  end

  describe '#unfollow' do
    it 'userに関連するrelationshipのデータを削除すること' do
      user.follow(follow_user.id)
      expect { user.unfollow(follow_user.id) }.to change { user.relationships.count }.by(-1)
    end
  end

  describe '#following?' do
    context 'userに関連するrelationshipのデータの中で、属性のfollow_idが引数のデータがある場合' do
      it 'trueを返すこと' do
        user.follow(follow_user.id)
        expect(user.following?(follow_user.id)).to be true
      end
    end

    context 'userに関連するrelationshipのデータの中で、属性のfollow_idが引数のデータがない場合' do
      it 'falseを返すこと' do
        expect(user.following?(follow_user.id)).to be false
      end
    end
  end
end
