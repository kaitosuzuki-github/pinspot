require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  describe 'POST /posts/:post_id/bookmarks' do
    let(:current_user) { create(:user) }
    let(:bookmark_post) { create(:post) }

    context '正常な場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        post post_bookmarks_path(bookmark_post.id)
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkを作成すること' do
        expect { post post_bookmarks_path(bookmark_post.id) }.to change { current_user.bookmarks.count }.by(1)
      end

      it 'トップページにリダイレクトすること' do
        post post_bookmarks_path(bookmark_post.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインせずに,ブックマークした場合' do
      it 'レスポンスコード302を返すこと' do
        post post_bookmarks_path(bookmark_post.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインページにリダイレクトすること' do
        post post_bookmarks_path(bookmark_post.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ユーザーがすでにブックマークしていた場合' do
      before do
        sign_in current_user
        current_user.bookmarks.create(post_id: bookmark_post.id)
      end

      it 'レスポンスコード302を返すこと' do
        post post_bookmarks_path(bookmark_post.id)
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkを作成しないこと' do
        expect { post post_bookmarks_path(bookmark_post.id) }.to change { current_user.bookmarks.count }.by(0)
      end

      it 'トップページにリダイレクトすること' do
        post post_bookmarks_path(bookmark_post.id)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE /posts/:post_id/bookmarks' do
    let(:current_user) { create(:user) }
    let(:bookmark_post) { create(:post) }

    context '正常な場合' do
      before do
        sign_in current_user
        current_user.bookmarks.create(post_id: bookmark_post.id)
      end

      it 'レスポンスコード302を返すこと' do
        delete post_bookmarks_path(bookmark_post.id)
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkを削除すること' do
        expect { delete post_bookmarks_path(bookmark_post.id) }.to change { current_user.bookmarks.count }.by(-1)
      end

      it 'トップページにリダイレクトすること' do
        delete post_bookmarks_path(bookmark_post.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインせずに、ブックマークを削除した場合' do
      before do
        current_user.bookmarks.create(post_id: bookmark_post.id)
      end

      it 'レスポンスコード302を返すこと' do
        delete post_bookmarks_path(bookmark_post.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインページにリダイレクトすること' do
        delete post_bookmarks_path(bookmark_post.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ユーザーがブックマークしていなかった場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        delete post_bookmarks_path(bookmark_post.id)
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkを削除しないこと' do
        expect { delete post_bookmarks_path(bookmark_post.id) }.to change { current_user.bookmarks.count }.by(0)
      end

      it 'トップページにリダイレクトすること' do
        delete post_bookmarks_path(bookmark_post.id)
        expect(response).to redirect_to root_path
      end
    end
  end
end
