require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validation' do
    let(:post) { build(:post) }

    context 'titleの文字列が100文字以内である場合' do
      it '許可すること' do
        post.title = 'a' * 100
        expect(post).to be_valid
      end
    end

    context 'titleの文字列が100文字より多い場合' do
      it '許可しないこと' do
        post.title = 'a' * 101
        expect(post).to be_invalid
      end
    end

    context 'descriptionの文字列が1000文字以内である場合' do
      it '許可すること' do
        post.description = 'a' * 1000
        expect(post).to be_valid
      end
    end

    context 'descriptionの文字列が1000文字より多い場合' do
      it '許可しないこと' do
        post.description = 'a' * 1001
        expect(post).to be_invalid
      end
    end

    context 'locationの文字列が255文字以内である場合' do
      it '許可すること' do
        post.location = 'a' * 255
        expect(post).to be_valid
      end
    end

    context 'locationの文字列が256文字より多い場合' do
      it '許可しないこと' do
        post.location = 'a' * 256
        expect(post).to be_invalid
      end
    end

    context '有効な画像の場合(imageの画像の形式がjpeg、サイズが15MBより小さい、横幅の画素数が400px以上、高さの画素数が400px以上)' do
      it '許可すること' do
        expect(post).to be_valid
      end
    end

    context 'imageに画像がアタッチされていない場合' do
      it '許可しないこと' do
        post.image = nil
        expect(post).to be_invalid
      end
    end

    context 'imageの画像の形式がpngの場合' do
      it '許可すること' do
        post.image = fixture_file_upload('file_type_png.png')
        expect(post).to be_valid
      end
    end

    context 'imageの画像の形式がjpegまたはpngではない場合' do
      it '許可しないこと' do
        post.image = fixture_file_upload('file_type_pdf.pdf')
        expect(post).to be_invalid
      end
    end

    context 'imageの画像のサイズが15MB以上の場合' do
      it '許可しないこと' do
        post.image = fixture_file_upload('size_bigger_than_15mb.png')
        expect(post).to be_invalid
      end
    end

    context 'imageの画像の横幅の画素数が400pxより小さい場合' do
      it '許可しないこと' do
        post.image = fixture_file_upload('width_smaller_than_400px.jpg')
        expect(post).to be_invalid
      end
    end

    context 'imageの画像の高さの画素数が400pxより小さい場合' do
      it '許可しないこと' do
        post.image = fixture_file_upload('height_smaller_than_400px.jpg')
        expect(post).to be_invalid
      end
    end
  end
end
