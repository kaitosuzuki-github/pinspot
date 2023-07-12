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

      it 'レスポンスコード302が返ってくること' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkが作成されること' do
        expect { subject }.to change { user.bookmarks.count }.by(1)
      end

      it 'トップページにリダイレクトすること' do
        subject
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインせずにブックマークした場合' do
      before do
        subject
      end

      it 'レスポンスコード302が返ってくること' do
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

      it 'レスポンスコード302が返ってくること' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkが作成されないこと' do
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

      it 'レスポンスコード302が返ってくること' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'ユーザーに関連するブックマークが削除されること' do
        expect { subject }.to change { user.bookmarks.count }.by(-1)
      end

      it 'トップページにリダイレクトされること' do
        subject
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインせずに、ブックマークを削除した場合' do
      before do
        user.bookmarks.create(post_id: bookmark_post.id)
        subject
      end

      it 'レスポンスコード302が返ってくること' do
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトされること' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ユーザーがブックマークしていなかった場合' do
      before do
        sign_in user
      end

      it 'レスポンスコード302が返ってくること' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'userに関連するbookmarkが削除されないこと' do
        expect { subject }.to change { user.bookmarks.count }.by(0)
      end

      it 'トップページへリダイレクトされること' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end
end
