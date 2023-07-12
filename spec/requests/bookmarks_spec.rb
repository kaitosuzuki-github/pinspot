require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  describe 'POST /posts/:post_id/bookmarks' do
    let(:user) { create(:user) }
    let(:bookmark_post) { create(:post) }

    context '正常な場合' do
      before do
        sign_in user
      end

      it 'レスポンスコードの302が返ってくること' do
        post post_bookmarks_path(bookmark_post.id)
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkが作成されること' do
        expect { post(post_bookmarks_path(bookmark_post.id)) }.to change { user.bookmarks.count }.by(1)
      end

      it 'トップページにリダイレクトすること' do
        post post_bookmarks_path(bookmark_post.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインせずにブックマークした場合' do
      it 'サインインページにリダイレクトすること' do
        post post_bookmarks_path(bookmark_post.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ユーザーがすでにブックマークしていた場合' do
      before do
        sign_in user
        user.bookmarks.create(post_id: bookmark_post.id)
      end

      it 'userに関連するbookmarkが作成されないこと' do
        expect { post(post_bookmarks_path(bookmark_post.id)) }.to change { user.bookmarks.count }.by(0)
      end

      it 'トップページにリダイレクトすること' do
        post post_bookmarks_path(bookmark_post.id)
        expect(response).to redirect_to root_path
      end
    end
  end
end
