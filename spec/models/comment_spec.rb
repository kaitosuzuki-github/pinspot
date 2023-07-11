require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validation' do
    let(:comment) { build(:comment) }

    context 'contentの文字数が255文字以下の場合' do
      it '許可すること' do
        comment.content = 'a' * 255
        expect(comment).to be_valid
      end
    end

    context 'contentの文字数が255文字より多い場合' do
      it '許可しないこと' do
        comment.content = 'a' * 256
        expect(comment).to be_invalid
      end
    end
  end
end
