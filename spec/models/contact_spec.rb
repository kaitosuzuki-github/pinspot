require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'validation' do
    let(:contact) { build(:contact) }

    context 'emailの文字数が255文字以下の場合' do
      it '許可する' do
        contact.email = "#{'a' * 243}@example.com"
        expect(contact).to be_valid
      end
    end

    context 'emailの文字数が255文字より多い場合' do
      it '許可しない' do
        contact.email = "#{'a' * 244}@example.com"
        expect(contact).to be_invalid
      end
    end

    context 'emailにアットマーク(@)とドット(.)がある場合' do
      it '許可する' do
        contact.email = 'example@example.com'
        expect(contact).to be_valid
      end
    end

    context 'emailにアットマーク(@)がない場合' do
      it '許可しない' do
        contact.email = 'exampl-example.com'
        expect(contact).to be_invalid
      end
    end

    context 'emailにドット(.)がない場合' do
      it '許可しない' do
        contact.email = 'examplp@example-com'
        expect(contact).to be_invalid
      end
    end

    context 'emailで、アットマーク(@)の前の文字列に英大文字が1文字以上ある場合' do
      it '許可する' do
        contact.email = 'A@example.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の前の文字列に英小文字が1文字以上ある場合' do
      it '許可する' do
        contact.email = 'a@example.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の前の文字列に数字が1文字以上ある場合' do
      it '許可する' do
        contact.email = '1@example.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の前の文字列にアンダーバー(_)が1文字以上ある場合' do
      it '許可する' do
        contact.email = '_@example.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の前の文字列にプラス(+)が1文字以上ある場合' do
      it '許可する' do
        contact.email = '+@example.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の前の文字列にハイフン(-)が1文字以上ある場合' do
      it '許可する' do
        contact.email = '-@example.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の前の文字列にドット(.)が1文字以上ある場合' do
      it '許可する' do
        contact.email = '.@example.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の前の文字列に英数字、アンダーバー (_)、プラス (+)、ハイフン (-)、ドット (.)ではない文字がある場合' do
      it '許可しない' do
        contact.email = '#@example.com'
        expect(contact).to be_invalid
      end
    end

    context 'emailで、アットマーク(@)の前の文字列がない場合' do
      it '許可しない' do
        contact.email = '@example.com'
        expect(contact).to be_invalid
      end
    end

    context 'emailで、アットマーク(@)の後ろの文字列に英大文字が1文字以上ある場合' do
      it '許可する' do
        contact.email = 'example@A.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の後ろの文字列に英小文字が1文字以上ある場合' do
      it '許可する' do
        contact.email = 'example@a.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の後ろの文字列に数字が1文字以上ある場合' do
      it '許可する' do
        contact.email = 'example@1.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の後ろの文字列にハイフン(-)が1文字以上ある場合' do
      it '許可する' do
        contact.email = 'example@-.com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の後ろの文字列にドット(.)が1文字以上ある場合' do
      it '許可する' do
        contact.email = 'example@..com'
        expect(contact).to be_valid
      end
    end

    context 'emailで、アットマーク(@)の後ろの文字列に英数字、ハイフン(-)、ドット(.)ではない文字がある場合' do
      it '許可しない' do
        contact.email = 'example@#.com'
        expect(contact).to be_invalid
      end
    end

    context 'emailで、アットマーク(@)の後ろの文字列がない場合' do
      it '許可しない' do
        contact.email = 'example@.com'
        expect(contact).to be_invalid
      end
    end

    context 'emailで、ドット(.)の後ろの文字列に英大文字が1文字以上ある場合' do
      it '許可する' do
        contact.email = 'example@example.A'
        expect(contact).to be_valid
      end
    end

    context 'emailで、ドット(.)の後ろの文字列に英小文字が1文字以上ある場合' do
      it '許可する' do
        contact.email = 'example@example.a'
        expect(contact).to be_valid
      end
    end

    context 'emailで、ドット(.)の後ろの文字列に英字ではない文字がある場合' do
      it '許可しない' do
        contact.email = 'example@example.1'
        expect(contact).to be_invalid
      end
    end

    context 'emailで、ドット(.)の後ろの文字列がない場合' do
      it '許可しない' do
        contact.email = 'example@example.'
        expect(contact).to be_invalid
      end
    end

    context 'subjectの文字数が255文字以下の場合' do
      it '許可する' do
        contact.subject = 'a' * 255
        expect(contact).to be_valid
      end
    end

    context 'subjectの文字数が255文字より多い場合' do
      it '許可しない' do
        contact.subject = 'a' * 256
        expect(contact).to be_invalid
      end
    end

    context 'messageの文字数が1000文字以下の場合' do
      it '許可する' do
        contact.message = 'a' * 1000
        expect(contact).to be_valid
      end
    end

    context 'messageの文字数が1000文字より多い場合' do
      it '許可しない' do
        contact.message = 'a' * 1001
        expect(contact).to be_invalid
      end
    end
  end
end
