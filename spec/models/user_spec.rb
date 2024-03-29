require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#follow' do
    let(:follow_user) { create(:user) }

    it 'userに関連するrelationshipのデータを作成すること' do
      expect { user.follow(follow_user.id) }.to change { user.relationships.count }.by(1)
    end
  end

  describe '#unfollow' do
    let(:follow_user) { create(:user) }

    it 'userに関連するrelationshipのデータを削除すること' do
      user.follow(follow_user.id)
      expect { user.unfollow(follow_user.id) }.to change { user.relationships.count }.by(-1)
    end
  end

  describe '#following?' do
    let(:follow_user) { create(:user) }

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
    let(:post) { create(:post) }

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
    let(:post) { create(:post) }

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
      let(:other_user) { create(:user) }

      it 'falseを返すこと' do
        expect(user.same_user?(other_user.id)).to be false
      end
    end

    context '引数の値が文字列の場合' do
      it 'trueを返すこと' do
        expect(user.same_user?(user.id.to_s)).to be true
      end
    end
  end

  describe '#self.guest' do
    context 'userのデータの中に、emailがguest@example.comのデータがない場合' do
      it 'userのデータが作成されること' do
        expect { User.guest }.to change { User.count }.by(1)
      end

      it 'profileのデータが作成されること' do
        expect { User.guest }.to change { Profile.count }.by(1)
      end
    end

    context 'userのデータの中に、emailがguest@example.comのデータがある場合' do
      it 'emailがguest@example.comのuserのデータを返すこと' do
        User.guest
        expect(User.guest).to eq User.find_by(email: 'guest@example.com')
      end
    end
  end
end
