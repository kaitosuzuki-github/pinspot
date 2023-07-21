require 'rails_helper'

RSpec.describe "Contacts", type: :system do
  describe 'new' do
    before do
      visit new_contact_path
    end

    context 'お問い合わせページに訪れた場合' do
      it 'title要素に「お問い合わせ」を表示すること' do
        expect(page).to have_title 'お問い合わせ'
      end

      it '「お問い合わせ」を表示すること' do
        within '#contacts_new' do
          expect(page).to have_selector 'h2', text: 'お問い合わせ'
        end
      end
    end

    context 'フォームの送信が成功した場合' do
      before do
        fill_in 'Eメール', with: Faker::Internet.email
        fill_in '件名', with: Faker::Lorem.sentence
        fill_in '内容', with: Faker::Lorem.paragraph
        click_button '送信する'
      end

      it 'お問い合わせページに遷移すること' do
        expect(current_path).to eq new_contact_path
      end

      it '「お問い合わせを受け付けました」を表示すること' do
        expect(page).to have_content 'お問い合わせを受け付けました'
      end
    end

    context 'フォームの送信がバリデーションエラーで失敗した場合' do
      before do
        click_button '送信する'
      end

      it '「エラー」を表示すること' do
        expect(page).to have_content 'エラー'
      end

      it 'エラーがあった部分を表示すること' do
        within '#errors' do
          expect(page).to have_content 'Eメール'
          expect(page).to have_content '件名'
          expect(page).to have_content '内容'
        end
      end

      it 'フォーム内の要素にfield_with_errorsクラスが付いていること' do
        expect(page).to have_css '.field_with_errors'
      end
    end
  end
end
