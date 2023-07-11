require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:follow_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post) }

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
    context 'userに関連するrelationshipのデータの中で、follow_idが引数の値であるデータがある場合' do
      it 'trueを返すこと' do
        user.follow(follow_user.id)
        expect(user.following?(follow_user.id)).to be true
      end
    end

    context 'userに関連するrelationshipのデータの中で、follow_idが引数の値であるデータがない場合' do
      it 'falseを返すこと' do
        expect(user.following?(follow_user.id)).to be false
      end
    end
  end

  describe '#bookmarking?' do
    context 'userに関連するbookmarkのデータの中で、post_idが引数の値であるデータがある場合' do
      it 'trueを返すこと' do
        user.bookmarks.create(post_id: post.id)
        expect(user.bookmarking?(post.id)).to be true
      end
    end

    context 'userに関連するbookmarkのデータの中で、post_idが引数の値であるデータがない場合' do
      it 'falseを返すこと' do
        expect(user.bookmarking?(post.id)).to be false
      end
    end
  end

  describe '#like?' do
    context 'userに関連するlikeのデータの中で、post_idが引数の値であるデータがある場合' do
      it 'trueを返すこと' do
        user.likes.create(post_id: post.id)
        expect(user.like?(post.id)).to be true
      end
    end

    context 'userに関連するlikeのデータの中で、post_idが引数の値であるデータがない場合' do
      it 'falseを返すこと' do
        expect(user.like?(post.id)).to be false
      end
    end
  end

  describe '#same_user?' do
    context 'userのidと引数の値が同じ場合' do
      it 'trueを返すこと' do
        expect(user.same_user?(user.id)).to be true
      end
    end

    context 'userのidと引数の値が違う場合' do
      it 'falseを返すこと' do
        expect(user.same_user?(other_user.id)).to be false
      end
    end
  end
end
