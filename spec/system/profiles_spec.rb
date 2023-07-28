require 'rails_helper'

RSpec.describe "Profiles", type: :system do
  describe 'show' do
    describe 'profiles' do
      let(:user) { create(:user) }

      context '一般的な場合' do
        let!(:post) { create(:post, user: user) }
        let(:follow_user) { create_list(:user, 2) }

        before do
          follow_user[0].follow(user.id)
          follow_user[1].follow(user.id)
          user.follow(follow_user[0].id)
          user.follow(follow_user[1].id)
          visit root_path
          visit profile_path(user.profile)
        end

        it 'title要素に投稿のタイトルを表示すること' do
          expect(page).to have_title "Pinspot - #{user.profile.name}"
        end

        it 'プロフィールのカバーが表示されていること' do
          expect(page).to have_selector "#profile #cover_display"
        end

        it 'プロフィールのアバターが表示されていること' do
          expect(page).to have_selector "#profile #avatar_display"
        end

        it 'プロフィールの名前が表示されていること' do
          within '#profile' do
            expect(page).to have_content user.profile.name
          end
        end

        it '戻るボタンを押すと、前のページにもどること', js: true do
          find('#profile #back_button').click
          expect(current_path).to eq root_path
        end

        it '設定ボタンを表示しないこと' do
          expect(page).to_not have_selector '#profile #config_button'
        end

        it 'プロフィールの紹介が表示されていること' do
          within '#profile' do
            expect(page).to have_content user.profile.introduction
          end
        end

        it 'プロフィールのフォロワー数を表示すること' do
          within '#profile' do
            expect(page).to have_content follow_user.size
          end
        end

        it '「フォロワー」を押すと、ログインページに遷移すること' do
          within '#profile' do
            click_link 'フォロワー'
          end

          expect(current_path).to eq new_user_session_path
        end

        it 'プロフィールのフォロー中の数を表示すること' do
          within '#profile' do
            expect(page).to have_content follow_user.size
          end
        end

        it '「フォロー中」を押すと、ログインページに遷移すること' do
          within '#profile' do
            click_link 'フォロー中'
          end

          expect(current_path).to eq new_user_session_path
        end

        it '「投稿」タブを押すと、ページ遷移しないこと' do
          find('#posts_tab').click
          expect(current_path).to eq profile_path(user.profile)
        end

        it '「いいねした投稿」タブを表示しないこと' do
          expect(page).to_not have_selector '#like_posts_tab'
        end

        it '「保存した投稿」タブを表示しないこと' do
          expect(page).to_not have_selector '#bookmark_posts_tab'
        end

        it 'プロフィールの投稿を表示すること' do
          expect(page).to have_content post.title
          expect(page).to have_selector "img[src$='#{post.image.filename}']"
        end
      end

      context 'ログインしている場合' do
        before do
          sign_in user
          visit profile_path(user.profile)
        end

        it '「フォロワー」を押すと、フォロワー一覧ページに遷移すること' do
          within '#profile' do
            click_link 'フォロワー'
          end

          expect(current_path).to eq followers_profile_path(user.profile)
        end

        it '「フォロー中」を押すと、フォロー中一覧ページに遷移すること' do
          within '#profile' do
            click_link 'フォロー中'
          end

          expect(current_path).to eq following_profile_path(user.profile)
        end

        it '「いいねした投稿」タブを押すと、いいねした投稿ページへ遷移すること' do
          find('#like_posts_tab').click
          expect(current_path).to eq show_likes_profile_path(user.profile)
        end
      end

      context 'ログインユーザーとプロフィールのユーザーが同じ場合' do
        before do
          sign_in user
          visit profile_path(user.profile)
        end

        it '設定ボタンを押すと、プロフィール設定ページに遷移すること' do
          find('#profile #config_button').click
          expect(current_path).to eq edit_profile_path(user.profile)
        end

        it '「保存した投稿」タブを押すと、保存した投稿ページへ遷移すること' do
          find('#bookmark_posts_tab').click
          expect(current_path).to eq show_bookmarks_profile_path(user.profile)
        end
      end

      context 'ログインユーザーとプロフィールのユーザーが異なる場合' do
        let(:other_user) { create(:user) }

        before do
          sign_in other_user
          visit profile_path(user.profile)
        end

        it '設定ボタンを表示しないこと' do
          expect(page).to_not have_selector '#profile #config_button'
        end

        it '「保存した投稿」タブを表示しないこと' do
          expect(page).to_not have_selector '#bookmark_posts_tab'
        end
      end
    end

    describe 'relationships' do
      let(:user) { create(:user) }

      context 'ログインしていない場合' do
        before do
          visit profile_path(user.profile)
        end

        it 'フォローボタンを押すと、ログインページへ遷移すること' do
          find('#follow_button').click
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'ログインユーザーとプロフィールのユーザーが同じ場合' do
        before do
          sign_in user
          visit profile_path(user.profile)
        end

        it 'フォローボタンを表示しないこと' do
          expect(page).to_not have_selector '#follow_button'
        end
      end

      context 'ログインユーザーとプロフィールのユーザーが異なる場合' do
        let(:other_user) { create(:user) }

        before do
          sign_in other_user
          visit profile_path(user.profile)
        end

        it '「フォローする」ボタンを押すと、「フォロー中」に変化すること' do
          within '#follow_button' do
            expect(page).to_not have_content 'フォロー中'
            expect(page).to have_content 'フォローする'
          end

          find('#follow_button').click

          within '#follow_button' do
            expect(page).to have_content 'フォロー中'
            expect(page).to_not have_content 'フォローする'
          end
        end

        it '「フォロー中」ボタンを押すと、「フォローする」に変化すること' do
          find('#follow_button').click

          within '#follow_button' do
            expect(page).to_not have_content 'フォローする'
            expect(page).to have_content 'フォロー中'
          end

          find('#follow_button').click

          within '#follow_button' do
            expect(page).to have_content 'フォローする'
            expect(page).to_not have_content 'フォロー中'
          end
        end
      end
    end
  end

  describe 'edit' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit profile_path(user.profile)
      visit edit_profile_path(user.profile)
    end

    context 'プロフィール編集ページを訪れた場合' do
      it 'title要素に「プロフィール編集」を表示すること' do
        expect(page).to have_title 'Pinspot - プロフィール編集'
      end

      it '「プロフィール編集」を表示すること' do
        expect(page).to have_selector '#profiles_edit h2', text: 'プロフィール編集'
      end

      it 'キャンセルボタンを押したとき、前のページに戻ること', js: true do
        within '#profiles_edit' do
          click_on 'キャンセル'
        end
        expect(current_path).to eq profile_path(user.profile)
      end
    end

    context 'フォームの送信に成功した場合' do
      before do
        within '#profiles_edit' do
          attach_file 'profile_cover', "#{Rails.root}/spec/fixtures/files/valid_image.jpg"
          attach_file 'profile_avatar', "#{Rails.root}/spec/fixtures/files/valid_image.jpg"
          fill_in '名前', with: Faker::Internet.username
          fill_in '紹介', with: Faker::Lorem.paragraph
          click_on '変更'
        end
      end

      it 'プロフィールページに遷移すること' do
        expect(current_path).to eq profile_path(user.profile)
      end

      it '「変更しました」を表示すること' do
        expect(page).to have_content '変更しました'
      end
    end

    context 'フォーム送信に失敗した場合' do
      before do
        within '#profiles_edit' do
          attach_file 'profile_cover', "#{Rails.root}/spec/fixtures/files/file_type_pdf.pdf"
          attach_file 'profile_avatar', "#{Rails.root}/spec/fixtures/files/file_type_pdf.pdf"
          fill_in '名前', with: ''
          fill_in '紹介', with: 'a' * 1001
          click_on '変更'
        end
      end

      it '「エラー」を表示すること' do
        within '#errors' do
          expect(page).to have_content 'エラー'
        end
      end

      it 'エラーがあった部分を表示すること' do
        within '#errors' do
          expect(page).to have_content 'カバー画像'
          expect(page).to have_content 'アバター画像'
          expect(page).to have_content '名前'
          expect(page).to have_content '紹介'
        end
      end

      it 'フォーム内の要素にfield_with_errorsクラスが付いていること' do
        expect(page).to have_css '.field_with_errors'
      end
    end
  end

  describe 'show_likes' do
    let(:user) { create(:user) }

    context 'ログインしている場合' do
      let(:post) { create(:post) }

      before do
        user.likes.create(post_id: post.id)
        sign_in user
        visit show_likes_profile_path(user.profile)
      end

      it '「投稿」タブを押すと、プロフィールの投稿ページへ遷移すること' do
        find('#posts_tab').click
        expect(current_path).to eq profile_path(user.profile)
      end

      it '「いいねした投稿」タブを押すと、ページ遷移しないこと' do
        find('#like_posts_tab').click
        expect(current_path).to eq show_likes_profile_path(user.profile)
      end

      it 'プロフィールのいいねした投稿を表示すること' do
        expect(page).to have_content post.title
        expect(page).to have_selector "img[src$='#{post.image.filename}']"
      end
    end

    context 'ログインユーザーとプロフィールのユーザーが同じ場合' do
      before do
        sign_in user
        visit profile_path(user.profile)
      end

      it '「保存した投稿」タブを押すと、保存した投稿ページへ遷移すること' do
        find('#bookmark_posts_tab').click
        expect(current_path).to eq show_bookmarks_profile_path(user.profile)
      end
    end

    context 'ログインユーザーとプロフィールのユーザーが異なる場合' do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
        visit profile_path(user.profile)
      end

      it '「保存した投稿」タブを表示しないこと' do
        expect(page).to_not have_selector '#bookmark_posts_tab'
      end
    end
  end

  describe 'show_bookmarks' do
    let(:user) { create(:user) }

    let(:post) { create(:post) }

    before do
      user.bookmarks.create(post_id: post.id)
      sign_in user
      visit show_bookmarks_profile_path(user.profile)
    end

    it '「投稿」タブを押すと、プロフィールの投稿ページへ遷移すること' do
      find('#posts_tab').click
      expect(current_path).to eq profile_path(user.profile)
    end

    it '「いいねした投稿」タブを押すと、いいねした投稿ページへ遷移すること' do
      find('#bookmark_posts_tab').click
      expect(current_path).to eq show_bookmarks_profile_path(user.profile)
    end

    it '「保存した投稿」タブを押すと、ページ遷移しないこと' do
      find('#bookmark_posts_tab').click
      expect(current_path).to eq show_bookmarks_profile_path(user.profile)
    end

    it 'プロフィールのブックマークした投稿を表示すること' do
      expect(page).to have_content post.title
      expect(page).to have_selector "img[src$='#{post.image.filename}']"
    end
  end

  describe 'followers' do
    let(:user) { create(:user) }
    let(:follow_user) { create(:user) }

    before do
      follow_user.follow(user.id)
      sign_in user
      visit root_path
      visit followers_profile_path(user.profile)
    end

    it 'title要素に「フォロワー」を表示すること' do
      expect(page).to have_title 'Pinspot - フォロワー'
    end

    it '戻るボタンを押すと、前のページにもどること', js: true do
      find('#followers #back_button').click
      expect(current_path).to eq root_path
    end

    it '「フォロワー」を表示すること' do
      within '#followers' do
        expect(page).to have_selector 'h2', text: 'フォロワー'
      end
    end

    it 'フォロワーのアバターを表示すること' do
      expect(page).to have_selector "#followers #avatar_display"
    end

    it 'フォロワーの名前を表示すること' do
      within '#followers' do
        expect(page).to have_content follow_user.profile.name
      end
    end

    it 'フォロワーの名前、アバターを押すと、フォロワーのプロフィールページへ遷移すること' do
      find('#follow_user #profile_link').click
      expect(current_path).to eq profile_path(follow_user.profile)
    end

    it '「フォローする」ボタンを押すと、「フォロー中」に変化すること' do
      within '#follow_button' do
        expect(page).to_not have_content 'フォロー中'
        expect(page).to have_content 'フォローする'
      end

      find('#follow_button').click

      within '#follow_button' do
        expect(page).to have_content 'フォロー中'
        expect(page).to_not have_content 'フォローする'
      end
    end

    it '「フォロー中」ボタンを押すと、「フォローする」に変化すること' do
      find('#follow_button').click

      within '#follow_button' do
        expect(page).to_not have_content 'フォローする'
        expect(page).to have_content 'フォロー中'
      end

      find('#follow_button').click

      within '#follow_button' do
        expect(page).to have_content 'フォローする'
        expect(page).to_not have_content 'フォロー中'
      end
    end
  end
end
