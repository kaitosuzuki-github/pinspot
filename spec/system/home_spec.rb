require 'rails_helper'

RSpec.describe "Home", type: :system do
  describe 'index' do
    let!(:posts) { create_list(:post, 5) }

    before do
      visit root_path
    end

    it 'title要素に「Pinspot」を表示すること' do
      expect(page).to have_title 'Pinspot'
    end

    it '「撮影スポットマップ」を表示すること' do
      within '#home_index' do
        expect(page).to have_selector 'h2', text: '撮影スポットマップ'
      end
    end

    it 'id=mapの要素のdata-poasts属性に投稿データが入っていること' do
      posts_json = posts.to_json(only: [:id, :title, :location, :latitude, :longitude])
      within '#home_index' do
        map = find 'div[data-google-map-target=map]'
        expect(map['data-posts']).to eq posts_json
      end
    end

    it '「新着投稿」を表示すること' do
      within '#home_index' do
        expect(page).to have_selector 'h2', text: '新着投稿'
      end
    end

    it '「さらに表示」リンクを押すと、投稿検索ページへ遷移すること' do
      within '#home_index' do
        click_on 'さらに表示'
        expect(current_path).to eq search_posts_path
      end
    end

    it '投稿名を新着順に4件表示すること' do
      within '#home_index' do
        expect(page).to have_content posts[4].title
        expect(page).to have_content posts[3].title
        expect(page).to have_content posts[2].title
        expect(page).to have_content posts[1].title
      end
    end

    it '投稿の画像を新着順に4件表示すること' do
      within '#home_index' do
        expect(page).to have_selector "img[src$='#{posts[4].image.filename}']"
        expect(page).to have_selector "img[src$='#{posts[3].image.filename}']"
        expect(page).to have_selector "img[src$='#{posts[2].image.filename}']"
        expect(page).to have_selector "img[src$='#{posts[1].image.filename}']"
      end
    end

    it '投稿を新着順の4件以外表示しないこと' do
      within '#home_index' do
        expect(page).to_not have_content posts[0].title
        expect(page).to_not have_selector "img[src$='#{posts[0].image.filename}']"
      end
    end
  end

  describe 'header' do
    context '一般的な場合' do
      let(:post) { create(:post) }

      before do
        visit root_path
      end

      it '「Pinspot」を押すと、トップページに留まるすること' do
        within 'header' do
          click_on 'Pinspot'
        end

        expect(current_path).to eq root_path
      end

      it '「探す」を押すと、投稿検索ページへ遷移すること' do
        find('header #search_link').click
        expect(current_path).to eq search_posts_path
      end

      it '検索窓で投稿を検索すると、投稿検索ページへ遷移し、検索した投稿を表示すること', js: true do
        within 'header #pc_layout' do
          fill_in 'q_title_or_location_cont', with: post.title
          find('#q_title_or_location_cont').send_keys :enter
        end

        sleep 5
        expect(current_path).to eq search_posts_path

        within '#posts_search' do
          expect(page).to have_selector "img[src$='#{post.image.filename}']"
          expect(find('.title-base',
          visible: false)).to have_selector('#non_visible_post_title', visible: false, text: post.title)
        end
      end

      it '「ゲストログイン」を押すと、トップページに留まり、「ゲストユーザーとしてログインしました」を表示すること' do
        within 'header #pc_layout' do
          click_on 'ゲストログイン'
        end

        expect(current_path).to eq root_path
        expect(page).to have_content 'ゲストユーザーとしてログインしました'
      end

      it '「ログイン」を押すと、ログインページに遷移すること' do
        within 'header #pc_layout' do
          click_on 'ログイン'
        end

        expect(current_path).to eq new_user_session_path
      end

      it '「新規登録」を押すと、新規登録ページに遷移すること' do
        within 'header #pc_layout' do
          click_on '新規登録'
        end

        expect(current_path).to eq new_user_registration_path
      end
    end

    context 'ログインしている場合' do
      let(:user) { create(:user) }

      before do
        sign_in user
        visit root_path
      end

      it 'ログインしたユーザーのアバターを表示すること' do
        within 'header #pc_layout' do
          expect(page).to have_selector '#avatar_display'
        end
      end

      it 'ドロップダウンメニューを非表示にすること', js: true do
        within 'header #pc_layout' do
          expect(find('div[data-dropdown-target=menu]', visible: false)).to_not be_visible
        end
      end

      it 'ドロップダウンメニューの「プロフィール」を押すと、プロフィールページに遷移すること' do
        within 'header #pc_layout div[data-dropdown-target=menu]' do
          click_link 'プロフィール'
        end

        expect(current_path).to eq profile_path(user.profile.id)
      end

      it 'ドロップダウンメニューの「アカウント設定」を押すと、アカウント設定ページに遷移すること' do
        within 'header #pc_layout div[data-dropdown-target=menu]' do
          click_link 'アカウント設定'
        end

        expect(current_path).to eq users_show_path
      end

      it 'ドロップダウンメニューの「お問い合わせ」を押すと、新規お問い合わせページに遷移すること' do
        within 'header #pc_layout div[data-dropdown-target=menu]' do
          click_link 'お問い合わせ'
        end

        expect(current_path).to eq new_contact_path
      end

      it 'ドロップダウンメニューの「ログアウト」を押すと、トップページに留まり、「ログアウトしました。」を表示すること' do
        within 'header #pc_layout div[data-dropdown-target=menu]' do
          click_button 'ログアウト'
        end

        expect(current_path).to eq root_path
        expect(page).to have_content 'ログアウトしました。'
      end

      it '「投稿する」を押すと、新規投稿ページへ遷移すること' do
        within 'header #pc_layout' do
          click_link '投稿する'
        end

        expect(current_path).to eq new_post_path
      end
    end
  end

  describe 'footer' do
    before do
      visit root_path
    end

    it '「お問い合わせ」を押すと、新規お問い合わせページへ遷移すること' do
      within 'footer' do
        click_on 'お問い合わせ'
      end

      expect(current_path).to eq new_contact_path
    end

    it 'ツイッターアイコンを押すと、ツイッターのページへ遷移すること', js: true do
      find('footer #twitter_link').click
      switch_to_window(windows.last)
      expect(current_url).to eq ENV['TWITTER_LINK']
    end

    it 'githubアイコンを押すと、githubのページへ遷移すること', js: true do
      find('footer #github_link').click
      switch_to_window(windows.last)
      expect(current_url).to eq ENV['GITHUB_LINK']
    end

    it 'コピーライトを表示すること' do
      within 'footer' do
        expect(page).to have_content '© 2023 - Present Pinspot. All rights reserved.'
      end
    end
  end
end
