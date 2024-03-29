require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'validation' do
    let(:profile) { build(:profile) }

    context 'nameの文字列が100文字以内である場合' do
      it '許可すること' do
        profile.name = 'a' * 100
        expect(profile).to be_valid
      end
    end

    context 'nameの文字列が100文字より多い場合' do
      it '許可しないこと' do
        profile.name = 'a' * 101
        expect(profile).to be_invalid
      end
    end

    context 'introductionの文字列が1000文字以内である場合' do
      it '許可すること' do
        profile.introduction = 'a' * 1000
        expect(profile).to be_valid
      end
    end

    context 'introductionの文字列が1000文字より多い場合' do
      it '許可しないこと' do
        profile.introduction = 'a' * 1001
        expect(profile).to be_invalid
      end
    end

    context '有効な画像の場合(coverの画像の形式がjpeg、サイズが15MBより小さい、横幅の画素数が400px以上、高さの画素数が400px以上)' do
      it '許可すること' do
        expect(profile).to be_valid
      end
    end

    context 'coverの画像の形式がpngの場合' do
      it '許可すること' do
        profile.cover = fixture_file_upload('file_type_png.png')
        expect(profile).to be_valid
      end
    end

    context 'coverの画像の形式がjpegまたはpngではない場合' do
      it '許可しないこと' do
        profile.cover = fixture_file_upload('file_type_pdf.pdf')
        expect(profile).to be_invalid
      end
    end

    context 'coverの画像のサイズが15MB以上の場合' do
      it '許可しないこと' do
        profile.cover = fixture_file_upload('size_bigger_than_15mb.png')
        expect(profile).to be_invalid
      end
    end

    context 'coverの画像の横幅の画素数が400pxより小さい場合' do
      it '許可しないこと' do
        profile.cover = fixture_file_upload('width_smaller_than_400px.jpg')
        expect(profile).to be_invalid
      end
    end

    context 'coverの画像の高さの画素数が400pxより小さい場合' do
      it '許可しないこと' do
        profile.cover = fixture_file_upload('height_smaller_than_400px.jpg')
        expect(profile).to be_invalid
      end
    end

    context '有効な画像の場合(avatarの画像の形式がjpeg、サイズが15MBより小さい)' do
      it '許可すること' do
        expect(profile).to be_valid
      end
    end

    context 'avatarの画像の形式がpngの場合' do
      it '許可すること' do
        profile.avatar = fixture_file_upload('file_type_png.png')
        expect(profile).to be_valid
      end
    end

    context 'avatarの画像の形式がjpegまたはpngではない場合' do
      it '許可しないこと' do
        profile.avatar = fixture_file_upload('file_type_pdf.pdf')
        expect(profile).to be_invalid
      end
    end

    context 'avatarの画像のサイズが15MB以上の場合' do
      it '許可しないこと' do
        profile.avatar = fixture_file_upload('size_bigger_than_15mb.png')
        expect(profile).to be_invalid
      end
    end
  end
end
