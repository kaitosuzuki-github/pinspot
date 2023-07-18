require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe 'GET /posts/:id' do
    let(:post) { create(:post) }
    let!(:comment) { create(:comment, post: post) }

    context 'サインインしている場合' do
      let(:current_user) { create(:user) }

      before do
        sign_in current_user
      end

      it '正常なレスポンスを返すこと' do
        get post_path(post.id)
        expect(response).to have_http_status(:success)
      end

      it '投稿名を表示すること' do
        get post_path(post.id)
        expect(response.body).to include post.title
      end

      it '投稿に関連するコメントを表示すること' do
        get post_path(post.id)
        expect(response.body).to include comment.content
      end
    end

    context 'サインインしていない場合' do
      it '正常なレスポンスを返すこと' do
        get post_path(post.id)
        expect(response).to have_http_status(:success)
      end

      it '投稿名を表示すること' do
        get post_path(post.id)
        expect(response.body).to include post.title
      end

      it '投稿に関連するコメントを表示しないこと' do
        get post_path(post.id)
        expect(response.body).to_not include comment.content
      end
    end
  end

  describe 'GET /posts/new' do
    context 'サインインしている場合' do
      let(:current_user) { create(:user) }

      before do
        sign_in current_user
      end

      it '正常なレスポンスを返すこと' do
        get new_post_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'サインインしていない場合' do
      it 'レスポンスコード302を返すこと' do
        get new_post_path
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        get new_post_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
