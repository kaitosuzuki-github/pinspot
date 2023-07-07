require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validation' do
    context 'contentの文字数が255文字以下の場合' do
      let(:comment) { build(:comment, content: 'a' * 255) }

      it '有効であること' do
        expect(comment).to be_valid
      end
    end

    context 'contentの文字数が255文字より多い場合' do
      let(:comment) { build(:comment, content: 'a' * 256) }

      it '無効であること' do
        expect(comment).to be_invalid
      end
    end
  end
end
