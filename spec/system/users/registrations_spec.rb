require 'rails_helper'

RSpec.describe "Users::Registrations", type: :system do
  describe 'new' do
    before do
      visit new_user_registration_path
    end

    context 'お問い合わせページに訪れた場合' do
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
end
