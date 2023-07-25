require 'rails_helper'

RSpec.describe "Posts", type: :system do
  describe 'show' do
    describe 'posts' do
      let(:post) { create(:post) }
      let(:categories) { create_list(:category, 2) }

      context '投稿ページに訪れた場合' do
        before do
          visit root_path
          visit post_path(post)
        end

        it 'title要素に 投稿のタイトルを表示すること' do
          expect(page).to have_title "Pinspot - #{post.title}"
        end

        it '戻るボタンを押したときに、前のページに戻ること', js: true do
          find('#post_main #back_button').click
          expect(current_path).to eq root_path
        end

        it '投稿の画像が表示されていること' do
          within '#post_main' do
            expect(page).to have_selector "img[src$='#{post.image.filename}']"
          end
        end

        it 'id=mapの要素のdata-latitude、data-longitude属性に投稿の緯度経度データが入っていること' do
          within '#post_main' do
            map = find '#map'
            expect(map['data-latitude']).to eq "#{post.latitude}"
            expect(map['data-longitude']).to eq "#{post.longitude}"
          end
        end

        it 'ドロップダウンメニューを表示しないこと' do
          expect(page).to_not have_selector '#post_detail #dropdownWrap'
        end

        it '投稿ユーザーのアバターを表示すること' do
          expect(page).to have_selector "#post_detail #avatar"
        end

        it '投稿ユーザーの名前を表示すること' do
          within '#post_detail' do
            expect(page).to have_content post.user.profile.name
          end
        end

        it '投稿ユーザーのアバター、名前を押すと、投稿ユーザーのプロフィール詳細ページへ遷移すること' do
          find('#post_detail #profile_link').click
          expect(current_path).to eq profile_path(post.user.profile)
        end

        it '投稿のタイトルを表示すること' do
          within '#post_detail' do
            expect(page).to have_content post.title
          end
        end

        it '「撮影スポット」を表示すること' do
          within '#post_detail' do
            expect(page).to have_content '撮影スポット'
          end
        end

        it '投稿の撮影スポットを押すと、撮影スポットで検索された検索ページへ遷移すること' do
          within '#post_detail' do
            click_on post.location
          end
          expect(current_path).to eq search_posts_path
          within '#search_form' do
            expect(page).to have_field 'タイトル あるいは 撮影スポット は以下を含む', with: post.location
          end
        end

        it '投稿のカテゴリーを押すと、カテゴリーがチェックされた検索ページへ遷移すること' do
          post.post_category_relations.create(category_id: categories[0].id)
          visit post_path(post)
          within '#post_detail' do
            click_on categories[0].name
          end
          expect(current_path).to eq search_posts_path
          within '#search_form' do
            expect(page).to have_checked_field categories[0].name
            expect(page).to_not have_checked_field categories[1].name
          end
        end

        it '投稿の説明を表示すること' do
          within '#post_detail' do
            expect(page).to have_content post.description
          end
        end

        it '投稿の時間を表示すること' do
          within '#post_detail' do
            expect(page).to have_content I18n.l post.created_at, format: :long
          end
        end
      end

      context 'ログインしているユーザーと投稿のユーザーが同じ場合' do
        before do
          sign_in post.user
          visit post_path(post)
        end

        it 'ドロップダウントグルを表示すること' do
          expect(page).to have_selector '#post_detail #dropdownToggle'
        end

        it 'ドロップダウンメニューを非表示にすること', js: true do
          expect(find('#post_detail #dropdownMenu', visible: false)).to_not be_visible
        end

        it 'ドロップダウンメニューの「編集」を押すと、投稿編集ページに遷移すること' do
          within '#post_detail #dropdownMenu' do
            click_link '編集'
            expect(current_path).to eq edit_post_path(post)
          end
        end

        it 'ドロップダウンメニューの「削除」を押すと、トップページへ遷移すること' do
          within '#post_detail #dropdownMenu' do
            click_button '削除'
            expect(current_path).to eq root_path
          end
        end

        it 'ドロップダウンメニューの「削除」を押すと、「投稿を削除しました」を表示すること' do
          within '#post_detail #dropdownMenu' do
            click_button '削除'
          end
          expect(page).to have_content '投稿を削除しました'
        end
      end
    end

    describe 'likes' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }

      context 'ログインせずに、投稿ページに訪れた場合' do
        before do
          visit post_path(post)
        end

        it 'いいねボタンを押すと、ログインページへ遷移すること' do
          find('#post_detail #like_button').click
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'ログインして投稿ページに訪れ、投稿にいいねを押す場合' do
        before do
          sign_in user
          visit post_path(post)
        end

        it 'いいねされていないいいねボタンを押すと、いいねされたいいねボタンに変化すること' do
          expect(page).to have_selector '#post_detail #like_button .fill-none'
          expect(page).to_not have_selector '#post_detail #like_button .fill-current'
          find('#post_detail #like_button').click
          expect(page).to_not have_selector '#post_detail #like_button .fill-none'
          expect(page).to have_selector '#post_detail #like_button .fill-current'
        end
      end

      context 'ログインして投稿ページに訪れ、投稿からいいねを削除する場合' do
        before do
          sign_in user
          user.likes.create(post_id: post.id)
          visit post_path(post)
        end

        it 'いいねされたいいねボタンを押すと、いいねされていないいいねボタンに変化すること' do
          expect(page).to_not have_selector '#post_detail #like_button .fill-none'
          expect(page).to have_selector '#post_detail #like_button .fill-current'
          find('#post_detail #like_button').click
          expect(page).to have_selector '#post_detail #like_button .fill-none'
          expect(page).to_not have_selector '#post_detail #like_button .fill-current'
        end
      end
    end

    describe 'bookmarks' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }

      context 'ログインせずに、投稿ページに訪れた場合' do
        before do
          visit post_path(post)
        end

        it 'ブックマークボタンを押すと、ログインページへ遷移すること' do
          find('#post_detail #bookmark_button').click
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'ログインして投稿ページに訪れ、投稿にブックマークを押す場合' do
        before do
          sign_in user
          visit post_path(post)
        end

        it 'ブックマークされていないブックマークボタンを押すと、ブックマークがされたブックマークボタンに変化すること' do
          expect(page).to have_selector '#post_detail #bookmark_button .fill-none'
          expect(page).to_not have_selector '#post_detail #bookmark_button .fill-current'
          find('#post_detail #bookmark_button').click
          expect(page).to_not have_selector '#post_detail #bookmark_button .fill-none'
          expect(page).to have_selector '#post_detail #bookmark_button .fill-current'
        end
      end

      context 'ログインして投稿ページに訪れ、投稿からブックマークを削除する場合' do
        before do
          sign_in user
          user.bookmarks.create(post_id: post.id)
          visit post_path(post)
        end

        it 'ブックマークされたブックマークボタンを押すと、ブックマークされていないブックマークボタンに変化すること' do
          expect(page).to_not have_selector '#post_detail #bookmark_button .fill-none'
          expect(page).to have_selector '#post_detail #bookmark_button .fill-current'
          find('#post_detail #bookmark_button').click
          expect(page).to have_selector '#post_detail #bookmark_button .fill-none'
          expect(page).to_not have_selector '#post_detail #bookmark_button .fill-current'
        end
      end
    end
  end
end
