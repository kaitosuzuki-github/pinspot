require 'rails_helper'

RSpec.describe "Posts", type: :system do
  describe 'show' do
    describe 'posts' do
      let(:post) { create(:post) }
      let(:categories) { create_list(:category, 2) }

      context '一般的な場合' do
        before do
          visit root_path
          visit post_path(post)
        end

        it 'title要素に投稿のタイトルを表示すること' do
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
          expect(page).to have_selector "#post_detail #avatar_display"
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

      context 'ログインしていない場合' do
        before do
          visit post_path(post)
        end

        it 'いいねボタンを押すと、ログインページへ遷移すること', js: true do
          find('#post_detail #like_button').click
          sleep 5
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'ログインしていて、投稿にいいねしていない場合' do
        before do
          sign_in user
          visit post_path(post)
        end

        it 'いいねボタンを押すと、いいねされたいいねボタンに変化すること', js: true do
          expect(page).to have_selector '#post_detail #like_button .fill-none'
          expect(page).to_not have_selector '#post_detail #like_button .fill-current'
          find('#post_detail #like_button').click
          expect(page).to_not have_selector '#post_detail #like_button .fill-none'
          expect(page).to have_selector '#post_detail #like_button .fill-current'
        end
      end

      context 'ログインしていて、投稿にいいねしている場合' do
        before do
          sign_in user
          user.likes.create(post_id: post.id)
          visit post_path(post)
        end

        it 'いいねボタンを押すと、いいねされていないいいねボタンに変化すること', js: true do
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

      context 'ログインしていない場合' do
        before do
          visit post_path(post)
        end

        it 'ブックマークボタンを押すと、ログインページへ遷移すること', js: true do
          find('#post_detail #bookmark_button').click
          sleep 5
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'ログインしていて、投稿にブックマークしていない場合' do
        before do
          sign_in user
          visit post_path(post)
        end

        it 'ブックマークボタンを押すと、ブックマークがされたブックマークボタンに変化すること', js: true do
          expect(page).to have_selector '#post_detail #bookmark_button .fill-none'
          expect(page).to_not have_selector '#post_detail #bookmark_button .fill-current'
          find('#post_detail #bookmark_button').click
          expect(page).to_not have_selector '#post_detail #bookmark_button .fill-none'
          expect(page).to have_selector '#post_detail #bookmark_button .fill-current'
        end
      end

      context 'ログインしていて、投稿にブックマークしている場合' do
        before do
          sign_in user
          user.bookmarks.create(post_id: post.id)
          visit post_path(post)
        end

        it 'ブックマークボタンを押すと、ブックマークされていないブックマークボタンに変化すること', js: true do
          expect(page).to_not have_selector '#post_detail #bookmark_button .fill-none'
          expect(page).to have_selector '#post_detail #bookmark_button .fill-current'
          find('#post_detail #bookmark_button').click
          expect(page).to have_selector '#post_detail #bookmark_button .fill-none'
          expect(page).to_not have_selector '#post_detail #bookmark_button .fill-current'
        end
      end
    end

    describe 'relationships' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }

      context 'ログインしていない場合' do
        before do
          visit post_path(post)
        end

        it '「フォロー中」を表示しないこと' do
          within '#post_detail' do
            expect(page).to_not have_content 'フォロー中'
          end
        end

        it '「フォローする」を押すと、ログインページへ遷移すること', js: true do
          within '#post_detail' do
            click_on 'フォローする'
          end
          sleep 5
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'ログインユーザーと投稿ユーザーが同じ場合' do
        before do
          sign_in post.user
          visit post_path(post)
        end

        it '「フォローする」を表示しないこと' do
          within '#post_detail' do
            expect(page).to_not have_content 'フォローする'
          end
        end

        it '「フォロー中」を表示しないこと' do
          within '#post_detail' do
            expect(page).to_not have_content 'フォロー中'
          end
        end
      end

      context 'ログインユーザーと投稿ユーザーが異なり、ログインユーザーが投稿ユーザーをフォローしていない場合' do
        before do
          sign_in user
          visit post_path(post)
        end

        it '「フォローする」を押すと、「フォロー中」に変化すること', js: true do
          within '#post_detail' do
            expect(page).to_not have_content 'フォロー中'
            click_on 'フォローする'
            expect(page).to have_content 'フォロー中'
            expect(page).to_not have_content 'フォローする'
          end
        end
      end

      context 'ログインユーザーと投稿ユーザーが異なり、ログインユーザーが投稿ユーザーをすでにフォローしている場合', js: true do
        before do
          sign_in user
          user.follow(post.user.id)
          visit post_path(post)
        end

        it '「フォロー中」を押すと、確認ダイアログに「フォローをやめますか?」を表示すること' do
          within '#post_detail' do
            click_on 'フォロー中'
            expect(page.accept_confirm).to eq "フォローをやめますか?"
          end
        end

        it '「フォロー中」を押したあと、確認ダイアログで「はい」を押すと、「フォローする」に変化すること' do
          within '#post_detail' do
            expect(page).to_not have_content 'フォローする'
            page.accept_confirm do
              click_on 'フォロー中'
            end
            expect(page).to have_content 'フォローする'
            expect(page).to_not have_content 'フォロー中'
          end
        end
      end
    end

    describe 'comments' do
      let(:user) { create(:user) }

      context 'ログインしていない場合' do
        let(:comment) { create(:comment) }

        before do
          visit post_path(comment.post)
        end

        it 'コメント機能を表示しないこと' do
          expect(page).to_not have_selector '#comments'
        end
      end

      context 'ログインしていて、コメントがない場合' do
        let(:post) { create(:post) }

        before do
          sign_in user
          visit post_path(post)
        end

        it '「コメント (0)」を表示すること' do
          expect(page).to have_selector '#comments h3', text: 'コメント (0)'
        end

        it 'コメントがないとき、コメントを表示しないこと' do
          expect(page).to_not have_selector '#comment'
        end
      end

      context 'ログインしていて、コメントがある場合' do
        let(:post) { create(:post) }
        let!(:comments) { create_list(:comment, 2, post: post) }

        before do
          sign_in user
          visit post_path(post)
        end

        it '「コメント (コメント数)」を表示すること' do
          expect(page).to have_selector '#comments h3', text: "コメント (#{comments.size})"
        end

        it 'コメントを表示すること' do
          within first('#comment') do
            expect(page).to have_content comments[0].content
          end
        end

        it 'コメントの作成日時を表示すること' do
          within first('#comment') do
            expect(page).to have_content I18n.l comments[0].created_at, format: :long
          end
        end

        it 'コメントユーザーのアバターを表示すること' do
          within first('#comment') do
            expect(page).to have_selector '#avatar_display'
          end
        end

        it 'コメントユーザーの名前を表示すること' do
          within first('#comment') do
            expect(page).to have_content comments[0].user.profile.name
          end
        end

        it 'コメントユーザーを押すと、コメントユーザーのプロフィールページへ遷移すること', js: true do
          first('#comment #profile_link').click
          sleep 5
          expect(current_path).to eq profile_path(comments[0].user.profile)
        end
      end

      context 'ログインユーザーとコメントユーザーが同じ場合' do
        let(:comment) { create(:comment) }

        before do
          sign_in comment.user
          visit post_path(comment.post)
        end

        it 'コメントのドロップダウントグルを表示すること' do
          expect(page).to have_selector '#comment #dropdownWrap'
        end

        it 'コメントのドロップダウンメニューを非表示にすること', js: true do
          expect(find('#comment #dropdownMenu', visible: false)).to_not be_visible
        end

        it 'ドロップダウンメニューの「削除」を押すと、コメントを削除すること' do
          within '#comment' do
            click_on '削除'
          end
          expect(page).to_not have_selector '#comment'
        end
      end

      context 'ログインユーザーとコメントユーザーが異なる場合' do
        let(:comment) { create(:comment) }

        before do
          sign_in user
          visit post_path(comment.post)
        end

        it 'コメントのドロップダウンメニューを表示しないこと' do
          expect(page).to_not have_selector '#comment #dropdownWrap'
        end
      end

      context 'コメントフォームの送信が成功した場合' do
        let(:post) { create(:post) }

        before do
          sign_in user
          visit post_path(post)
        end

        it '送信したコメントを表示すること', js: true do
          expect(page).to_not have_selector '#comment'
          within '#comments' do
            fill_in 'Content', with: Faker::Lorem.paragraph
            click_button 'コメントする'
          end
          expect(page).to have_selector '#comment'
        end
      end

      context 'コメントフォームの送信が失敗した場合' do
        let(:post) { create(:post) }

        before do
          sign_in user
          visit post_path(post)
          within '#comments' do
            click_button 'コメントする'
          end
        end

        it 'コメントが作成されないこと', js: true do
          expect(page).to_not have_selector '#comment'
        end
      end
    end
  end

  describe 'new' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit new_post_path
    end

    context '新規投稿ページに訪れた場合' do
      it 'title要素に「新規投稿」を表示すること' do
        expect(page).to have_title 'Pinspot - 新規投稿'
      end

      it '「新規投稿」を表示すること' do
        expect(page).to have_selector '#posts_new h2', text: '新規投稿'
      end

      it 'キャンセルボタンを押したとき、前のページに戻ること', js: true do
        visit root_path
        visit new_post_path
        within '#posts_new' do
          click_on 'キャンセル'
        end
        expect(current_path).to eq root_path
      end
    end

    context 'フォームの送信が成功した場合' do
      before do
        within '#posts_new' do
          attach_file '写真', "#{Rails.root}/spec/fixtures/files/valid_image.jpg"
          fill_in '撮影スポット', with: Faker::Address.city
          find('#post_latitude', visible: false).set(Faker::Address.latitude)
          find('#post_longitude', visible: false).set(Faker::Address.longitude)
          fill_in 'タイトル', with: Faker::Lorem.word
          fill_in '説明', with: Faker::Lorem.sentence
          click_button '投稿'
        end
      end

      it '投稿ページに遷移すること' do
        expect(current_path).to eq post_path(Post.last)
      end

      it '「投稿しました」を表示すること' do
        expect(page).to have_content '投稿しました'
      end
    end

    context 'フォームの送信が失敗した場合' do
      before do
        within '#posts_new' do
          click_button '投稿'
        end
      end

      it '「エラー」を表示すること' do
        within '#posts_new #errors' do
          expect(page).to have_content 'エラー'
        end
      end

      it 'エラーがあった部分を表示すること' do
        within '#posts_new #errors' do
          expect(page).to have_content '写真'
          expect(page).to have_content '撮影スポット'
          expect(page).to have_content 'タイトル'
          expect(page).to have_content '説明'
        end
      end

      it '緯度、経度のエラーを表示しないこと' do
        within '#posts_new #errors' do
          expect(page).to_not have_content '緯度'
          expect(page).to_not have_content '経度'
        end
      end

      it 'フォーム内の要素にfield_with_errorsクラスが付いていること' do
        within '#posts_new' do
          expect(page).to have_css '.field_with_errors'
        end
      end
    end
  end

  describe 'edit' do
    let(:post) { create(:post) }

    before do
      sign_in post.user
      visit edit_post_path(post)
    end

    context '投稿編集ページに訪れた場合' do
      it 'title要素に「投稿編集」を表示すること' do
        expect(page).to have_title 'Pinspot - 投稿編集'
      end

      it '「投稿編集」を表示すること' do
        expect(page).to have_selector '#posts_edit h2', text: '投稿編集'
      end

      it 'キャンセルボタンを押したとき、前のページに戻ること', js: true do
        visit post_path(post)
        visit edit_post_path(post)
        within '#posts_edit' do
          click_on 'キャンセル'
        end
        expect(current_path).to eq post_path(post)
      end
    end

    context 'フォームの送信が成功した場合' do
      before do
        within '#posts_edit' do
          attach_file '写真', "#{Rails.root}/spec/fixtures/files/valid_image.jpg"
          fill_in '撮影スポット', with: Faker::Address.city
          find('#post_latitude', visible: false).set(Faker::Address.latitude)
          find('#post_longitude', visible: false).set(Faker::Address.longitude)
          fill_in 'タイトル', with: Faker::Lorem.word
          fill_in '説明', with: Faker::Lorem.sentence
          click_button '投稿'
        end
      end

      it '投稿ページに遷移すること' do
        expect(current_path).to eq post_path(post)
      end

      it '「変更しました」を表示すること' do
        expect(page).to have_content '変更しました'
      end
    end

    context 'フォームの送信が失敗した場合' do
      before do
        within '#posts_edit' do
          attach_file '写真', "#{Rails.root}/spec/fixtures/files/file_type_pdf.pdf"
          fill_in '撮影スポット', with: ''
          find('#post_latitude', visible: false).set('')
          find('#post_longitude', visible: false).set('')
          fill_in 'タイトル', with: ''
          fill_in '説明', with: ''
          click_button '投稿'
        end
      end

      it '「エラー」を表示すること' do
        within '#posts_edit #errors' do
          expect(page).to have_content 'エラー'
        end
      end

      it 'エラーがあった部分を表示すること' do
        within '#posts_edit #errors' do
          expect(page).to have_content '写真'
          expect(page).to have_content '撮影スポット'
          expect(page).to have_content 'タイトル'
          expect(page).to have_content '説明'
        end
      end

      it '緯度、経度のエラーを表示しないこと' do
        within '#posts_edit #errors' do
          expect(page).to_not have_content '緯度'
          expect(page).to_not have_content '経度'
        end
      end

      it 'フォーム内の要素にfield_with_errorsクラスが付いていること' do
        within '#posts_edit' do
          expect(page).to have_css '.field_with_errors'
        end
      end
    end
  end

  describe 'search' do
    let!(:posts) { create_list(:post, 2) }
    let(:category) { create(:category) }

    before do
      posts[0].post_category_relations.create(category_id: category.id)
      visit search_posts_path
    end

    it 'title要素に「検索」を表示すること' do
      expect(page).to have_title 'Pinspot - 検索'
    end

    it '「検索」を表示すること' do
      expect(page).to have_selector '#posts_search h2', text: '検索'
    end

    it '検索していないとき、すべての投稿が新しい順に表示されること' do
      within '#posts_search' do
        expect(page).to have_content posts[0].title
        expect(page).to have_selector "img[src$='#{posts[0].image.filename}']"
        expect(page).to have_content posts[1].title
        expect(page).to have_selector "img[src$='#{posts[1].image.filename}']"
        expect(page.text).to match %r{#{posts[1].title}[\s\S]*#{posts[0].title}}
      end
    end

    it 'キーワード検索したとき、検索結果の投稿のみが表示されること' do
      within '#search_form' do
        fill_in 'q_title_or_location_cont', with: posts[0].title
        click_on '検索'
      end
      within '#posts_search' do
        expect(page).to have_content posts[0].title
        expect(page).to have_selector "img[src$='#{posts[0].image.filename}']"
        expect(page).to_not have_content posts[1].title
        expect(page).to_not have_selector "img[src$='#{posts[1].image.filename}']"
      end
    end

    it 'カテゴリー検索したとき、検索結果の投稿のみが表示されること' do
      within '#search_form' do
        check category.name
        click_on category.name
      end
      within '#posts_search' do
        expect(page).to have_content posts[0].title
        expect(page).to have_selector "img[src$='#{posts[0].image.filename}']"
        expect(page).to_not have_content posts[1].title
        expect(page).to_not have_selector "img[src$='#{posts[1].image.filename}']"
      end
    end

    it 'ソートで「新しい投稿」にチェックをすると、新しい投稿順に並び替えられること' do
      within '#search_form' do
        choose '古い投稿'
        click_on '古い投稿'
        choose '新しい投稿'
        click_on '新しい投稿'
      end
      within '#posts_search' do
        expect(page.text).to match %r{#{posts[1].title}[\s\S]*#{posts[0].title}}
      end
    end

    it 'ソートで「古い投稿」にチェックをすると、古い投稿順に並び替えられること' do
      within '#search_form' do
        choose '古い投稿'
        click_on '古い投稿'
      end
      within '#posts_search' do
        expect(page.text).to match %r{#{posts[0].title}[\s\S]*#{posts[1].title}}
      end
    end
  end
end
