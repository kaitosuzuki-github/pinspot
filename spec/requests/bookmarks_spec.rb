require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let(:user) { create(:user) }
  let(:bookmark_post) { create(:post) }

  describe 'POST /posts/:post_id/bookmarks' do
    subject { post post_bookmarks_path(bookmark_post.id) }

    context '正常な場合' do
      before do
        sign_in user
      end

      it 'レスポンスコード302を返すこと' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkを作成すること' do
        expect { subject }.to change { user.bookmarks.count }.by(1)
      end

      it 'トップページにリダイレクトすること' do
        subject
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインせずに,ブックマークした場合' do
      before do
        subject
      end

      it 'レスポンスコード302を返すこと' do
        expect(response).to have_http_status(302)
      end

      it 'サインインページにリダイレクトすること' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ユーザーがすでにブックマークしていた場合' do
      before do
        sign_in user
        user.bookmarks.create(post_id: bookmark_post.id)
      end

      it 'レスポンスコード302を返すこと' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkを作成しないこと' do
        expect { subject }.to change { user.bookmarks.count }.by(0)
      end

      it 'トップページにリダイレクトすること' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE /posts/:post_id/bookmarks' do
    subject { delete post_bookmarks_path(bookmark_post.id) }

    context '正常な場合' do
      before do
        sign_in user
        user.bookmarks.create(post_id: bookmark_post.id)
      end

      it 'レスポンスコード302を返すこと' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkを削除すること' do
        expect { subject }.to change { user.bookmarks.count }.by(-1)
      end

      it 'トップページにリダイレクトすること' do
        subject
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインせずに、ブックマークを削除した場合' do
      before do
        user.bookmarks.create(post_id: bookmark_post.id)
        subject
      end

      it 'レスポンスコード302を返すこと' do
        expect(response).to have_http_status(302)
      end

      it 'サインインページにリダイレクトすること' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ユーザーがブックマークしていなかった場合' do
      before do
        sign_in user
      end

      it 'レスポンスコード302を返すこと' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkを削除しないこと' do
        expect { subject }.to change { user.bookmarks.count }.by(0)
      end

      it 'トップページにリダイレクトすること' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end
end
