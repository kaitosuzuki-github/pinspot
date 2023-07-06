require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validation' do
    context 'nameの文字数が100文字以下の場合' do
      let(:category) { build(:category, name: 'a' * 100) }

      it '有効であること' do
        expect(category).to be_valid
      end
    end

    context 'nameの文字数が100文字より多い場合' do
      let(:category) { build(:category, name: 'a' * 101) }

      it '無効であること' do
        expect(category).to be_invalid
      end
    end
  end
end
