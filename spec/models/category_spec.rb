require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validation' do
    let(:category) { build(:category) }

    context 'nameの文字数が100文字以下の場合' do
      it '許可すること' do
        category.name = 'a' * 100
        expect(category).to be_valid
      end
    end

    context 'nameの文字数が100文字より多い場合' do
      it '許可しないこと' do
        category.name = 'a' * 101
        expect(category).to be_invalid
      end
    end
  end
end
