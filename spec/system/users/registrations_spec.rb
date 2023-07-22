require 'rails_helper'

RSpec.describe "Users::Registrations", type: :system do
  describe 'new' do
    before do
      visit new_user_registration_path
    end

    context 'アカウント作成ページに訪れた場合' do
      it 'title要素に「新規登録」を表示すること' do
        expect(page).to have_title '新規登録'
      end
    end

    context 'フォームの送信が成功した場合' do
      before do
        password = Faker::Internet.password
        fill_in '名前', with: Faker::Name.name
        fill_in 'Eメール', with: Faker::Internet.email
        fill_in 'パスワード', with: password
        fill_in 'パスワード（確認用）', with: password
        click_button '登録'
      end

      it 'トップページに遷移すること' do
        expect(current_path).to eq root_path
      end

      it '「本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。」を表示すること' do
        expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
      end
    end

    context 'フォームの送信でprofileのnameを入力せず、バリデーションエラーで失敗した場合' do
      before do
        password = Faker::Internet.password
        fill_in 'Eメール', with: Faker::Internet.email
        fill_in 'パスワード', with: password
        fill_in 'パスワード（確認用）', with: password
        click_button '登録'
      end

      it '「エラー」を表示すること' do
        expect(page).to have_content 'エラー'
      end

      it 'profileのnameのエラーを表示すること' do
        within '#error_explanation' do
          expect(page).to have_content '名前'
        end
      end

      it 'フォーム内の要素にfield_with_errorsクラスが付いていること' do
        expect(page).to have_css '.field_with_errors'
      end
    end
  end

  describe 'show' do
    let(:current_user) { create(:user) }

    before do
      sign_in current_user
      visit users_show_path
    end

    context 'アカウント詳細ページに訪れた場合' do
      it 'title要素に「アカウント設定」を表示すること' do
        expect(page).to have_title 'アカウント設定'
      end

      it '「アカウント設定」を表示すること' do
        expect(page).to have_selector 'h2', text: 'アカウント設定'
      end

      it '「Eメール」を表示すること' do
        expect(page).to have_content 'Eメール'
      end

      it 'ログインしているユーザーのEメールを表示すること' do
        expect(page).to have_content current_user.email
      end

      it '「パスワード」を表示すること' do
        expect(page).to have_content 'パスワード'
      end

      it '「変更」リンクを押すと、ユーザー編集ページへ遷移すること' do
        click_link '変更'
        expect(current_path).to eq edit_user_registration_path
      end

      it '「削除」ボタンを押すと、確認ダイアログに「本当に削除しますか?」を表示すること', js: true do
        click_button '削除'
        expect(page.accept_confirm).to eq "本当に削除しますか?"
      end
    end

    context '削除ボタンを押したあと、確認ダイアログで「はい」を押した場合', js: true do
      before do
        page.accept_confirm do
          click_button '削除'
        end
      end

      it '「アカウントを削除しました。またのご利用をお待ちしております。」を表示すること' do
        expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
      end

      it 'トップページへ遷移すること' do
        expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
        expect(current_path).to eq root_path
      end
    end

    context '削除ボタンを押したあと、確認ダイアログで「いいえ」を押した場合', js: true do
      it 'アカウント詳細ページへ留まること' do
        page.dismiss_confirm do
          click_button '削除'
        end
        expect(current_path).to eq users_show_path
      end
    end
  end
end
