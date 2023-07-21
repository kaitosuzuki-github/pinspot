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
      expect(page).to have_selector 'h2', text: '撮影スポットマップ'
    end

    it 'id=mapの要素のdata-poasts属性に投稿データが入っていること' do
      posts_json = posts.to_json(only: [:id, :title, :location, :latitude, :longitude])
      map = find '#map'
      expect(map['data-posts']).to eq posts_json
    end

    it '「新着投稿」を表示すること' do
      expect(page).to have_selector 'h2', text: '新着投稿'
    end

    it '「さらに表示」リンクを押すと、投稿検索ページへ遷移すること' do
      click_on 'さらに表示'
      expect(current_path).to eq search_posts_path
    end

    it '投稿名を新着順に4件表示すること' do
      expect(page).to have_content posts[4].title
      expect(page).to have_content posts[3].title
      expect(page).to have_content posts[2].title
      expect(page).to have_content posts[1].title
    end

    it '投稿の画像を新着順に4件表示すること' do
      expect(page).to have_selector "img[src$='#{posts[4].image.filename}']"
      expect(page).to have_selector "img[src$='#{posts[3].image.filename}']"
      expect(page).to have_selector "img[src$='#{posts[2].image.filename}']"
      expect(page).to have_selector "img[src$='#{posts[1].image.filename}']"
    end

    it '投稿を新着順の4件以外表示しないこと' do
      expect(page).to_not have_content posts[0].title
      expect(page).to_not have_selector "img[src$='#{posts[0].image.filename}']"
    end
  end
end
