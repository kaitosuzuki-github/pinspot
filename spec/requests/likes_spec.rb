require 'rails_helper'

RSpec.describe "Likes", type: :request do
  describe 'POST /posts/:post_id/likes' do
    let(:current_user) { create(:user) }
    let(:like_post) { create(:post) }

    context '正常な場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        post post_likes_path(like_post.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインしているuserに関連するlikeを作成すること' do
        expect { post post_likes_path(like_post.id) }.to change { current_user.likes.count }.by(1)
      end

      it '作成されたlikeのpost_idはパラメータのpost_idであること' do
        post post_likes_path(like_post.id)
        expect(current_user.likes.last.post_id).to eq like_post.id
      end

      it 'トップページへリダイレクトすること' do
        post post_likes_path(like_post.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインしていない場合' do
      it 'レスポンスコード302を返すこと' do
        post post_likes_path(like_post.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        post post_likes_path(like_post.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ユーザーがすでにlikeをしている場合' do
      before do
        sign_in current_user
        current_user.likes.create(post_id: like_post.id)
      end

      it 'レスポンスコード302を返すこと' do
        post post_likes_path(like_post.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインしているuserに関連するlikeを作成しないこと' do
        expect { post post_likes_path(like_post.id) }.to change { current_user.likes.count }.by(0)
      end

      it 'トップページへリダイレクトすること' do
        post post_likes_path(like_post.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'パラメータのpost_idが存在しない値の場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        post post_likes_path(0)
        expect(response).to have_http_status(302)
      end

      it 'サインインしているuserに関連するlikeを作成しないこと' do
        expect { post post_likes_path(0) }.to change { current_user.likes.count }.by(0)
      end

      it 'トップページへリダイレクトすること' do
        post post_likes_path(0)
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'DELETE /posts/:post_id/likes' do
    let(:current_user) { create(:user) }
    let(:like_post) { create(:post) }

    context '正常な場合' do
      before do
        sign_in current_user
        current_user.likes.create(post_id: like_post.id)
      end

      it 'レスポンスコード302を返すこと' do
        delete post_likes_path(like_post.id)
        expect(response).to have_http_status(302)
      end

      it 'likeを削除すること' do
        expect { delete post_likes_path(like_post.id) }.to change { current_user.likes.count }.by(-1)
      end

      it 'トップページヘリダイレクトすること' do
        delete post_likes_path(like_post.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインしていない場合' do
      before do
        current_user.likes.create(post_id: like_post.id)
      end

      it 'レスポンスコード302を返すこと' do
        delete post_likes_path(like_post.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインページヘリダイレクトすること' do
        delete post_likes_path(like_post.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ユーザーがlikeを作成していない場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        delete post_likes_path(like_post.id)
        expect(response).to have_http_status(302)
      end

      it 'likeを削除しないこと' do
        expect { delete post_likes_path(like_post.id) }.to change { current_user.likes.count }.by(0)
      end

      it 'トップページヘリダイレクトすること' do
        delete post_likes_path(like_post.id)
        expect(response).to redirect_to root_path
      end
    end
  end
end
