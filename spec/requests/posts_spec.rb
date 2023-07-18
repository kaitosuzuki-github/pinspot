require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe 'GET /posts/:id' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    let!(:comment) { create(:comment, post: post) }

    context 'サインインしている場合' do
      before do
        sign_in user
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
end
