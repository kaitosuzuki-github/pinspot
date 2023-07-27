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
          expect(page).to have_selector "#profile #profile_cover"
        end

        it 'プロフィールのアバターが表示されていること' do
          expect(page).to have_selector "#profile #profile_avatar"
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
end
