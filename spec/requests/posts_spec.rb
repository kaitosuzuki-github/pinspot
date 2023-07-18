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

  describe 'POST /posts' do
    context '正常な場合' do
      let(:current_user) { create(:user) }

      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        post posts_path,
        :params => { :post => attributes_for(:post, image: fixture_file_upload('valid_image.jpg')) }
        expect(response).to have_http_status(302)
      end

      it 'ログインしているユーザーに関連する投稿を作成すること' do
        expect do
          post posts_path,
          :params => { :post => attributes_for(:post, image: fixture_file_upload('valid_image.jpg')) }
        end .to change { current_user.posts.count } .by(1)
      end

      it '「投稿しました」を表示すること' do
        post posts_path,
        :params => { :post => attributes_for(:post, image: fixture_file_upload('valid_image.jpg')) }
        expect(flash[:notice]).to include '投稿しました'
      end

      it '作成した投稿ページへリダイレクトすること' do
        post posts_path,
        :params => { :post => attributes_for(:post, image: fixture_file_upload('valid_image.jpg')) }
        expect(response).to redirect_to current_user.posts.last
      end
    end

    context 'サインインしていない場合' do
      it 'レスポンスコード302を返すこと' do
        post posts_path,
        :params => { :post => attributes_for(:post, image: fixture_file_upload('valid_image.jpg')) }
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        post posts_path,
        :params => { :post => attributes_for(:post, image: fixture_file_upload('valid_image.jpg')) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'パラメータが不正な場合' do
      let(:current_user) { create(:user) }

      before do
        sign_in current_user
      end

      it 'レスポンスコード422を返すこと' do
        post posts_path, :params => { :post => attributes_for(:post) }
        expect(response).to have_http_status(422)
      end

      it 'ログインしているユーザーに関連する投稿を作成しないこと' do
        expect { post posts_path, :params => { :post => attributes_for(:post) } }.to change { current_user.posts.count }.by(0)
      end

      it '「エラー」を表示すること' do
        post posts_path, :params => { :post => attributes_for(:post) }
        expect(response.body).to include 'エラー'
      end
    end
  end

  describe 'GET /posts/:id/edit' do
    let(:current_user) { create(:user) }
    let!(:post) { create(:post, user: current_user) }

    context '正常な場合' do
      before do
        sign_in current_user
      end

      it '正常なレスポンスを返すこと' do
        get edit_post_path(post.id)
        expect(response).to have_http_status(:success)
      end

      it 'ログインしているユーザーの投稿名を表示すること' do
        get edit_post_path(post.id)
        expect(response.body).to include post.title
      end
    end

    context 'サインインしていない場合' do
      it 'レスポンスコード302を返すこと' do
        get edit_post_path(post.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        get edit_post_path(post.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログインしているユーザーと投稿のユーザーが同じではない場合' do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
      end

      it 'レスポンスコード302を返すこと' do
        get edit_post_path(post.id)
        expect(response).to have_http_status(302)
      end

      it 'トップページへリダイレクトすること' do
        get edit_post_path(post.id)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PUT /posts/:id' do
    let(:current_user) { create(:user) }
    let!(:before_update_post) { create(:post, user: current_user) }

    context '正常な場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        put post_path(before_update_post.id),
        :params => { :post => attributes_for(:post, title: 'test', image: fixture_file_upload('file_type_png.png')) }
        expect(response).to have_http_status(302)
      end

      it 'ログインしているユーザーに関連する投稿名を編集すること' do
        expect do
          put post_path(before_update_post.id),
          :params => { :post => attributes_for(:post, title: 'test') }
        end .to change { current_user.posts.last.title }.from(before_update_post.title).to('test')
      end

      it '「変更しました」を表示すること' do
        put post_path(before_update_post.id),
        :params => { :post => attributes_for(:post) }
        expect(flash[:notice]).to include '変更しました'
      end

      it '編集した投稿ページへリダイレクトすること' do
        put post_path(before_update_post.id),
        :params => { :post => attributes_for(:post) }
        expect(response).to redirect_to before_update_post
      end
    end

    context 'サインインしていない場合' do
      it 'レスポンスコード302を返すこと' do
        put post_path(before_update_post.id),
        :params => { :post => attributes_for(:post) }
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        put post_path(before_update_post.id),
        :params => { :post => attributes_for(:post) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログインしているユーザーと投稿のユーザーが同じではない場合' do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
      end

      it 'レスポンスコード302を返すこと' do
        put post_path(before_update_post.id),
        :params => { :post => attributes_for(:post) }
        expect(response).to have_http_status(302)
      end

      it 'トップページへリダイレクトすること' do
        put post_path(before_update_post.id),
        :params => { :post => attributes_for(:post) }
        expect(response).to redirect_to root_path
      end
    end

    context 'パラメータが不正な場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード422を返すこと' do
        put post_path(before_update_post.id),
        :params => { :post => attributes_for(:post, title: nil) }
        expect(response).to have_http_status(422)
      end

      it 'ログインしているユーザーに関連する投稿名を編集しないこと' do
        expect do
          put post_path(before_update_post.id),
          :params => { :post => attributes_for(:post, title: nil) }
        end .to_not change { current_user.posts.last.title }
      end

      it '「エラー」を表示すること' do
        put post_path(before_update_post.id),
        :params => { :post => attributes_for(:post, title: nil) }
        expect(response.body).to include 'エラー'
      end
    end
  end
end
