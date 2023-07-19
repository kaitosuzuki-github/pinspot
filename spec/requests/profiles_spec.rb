require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  describe 'GET /profiles/:id' do
    let(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }

    it '正常なレスポンスを返すこと' do
      get profile_path(user.profile.id)
      expect(response).to have_http_status(:success)
    end

    it 'プロフィール名を表示すること' do
      get profile_path(user.profile.id)
      expect(response.body).to include user.profile.name
    end

    it 'プロフィールに関連した投稿名を表示すること' do
      get profile_path(user.profile.id)
      expect(response.body).to include user.posts.last.title
    end
  end

  describe 'GET /profiles/:id/edit' do
    let(:user) { create(:user) }

    context '正常な場合' do
      before do
        sign_in user
      end

      it '正常なレスポンスを返すこと' do
        get edit_profile_path(user.profile.id)
        expect(response).to have_http_status(:success)
      end

      it 'ログインしているプロフィール名を表示すること' do
        get edit_profile_path(user.profile.id)
        expect(response.body).to include user.profile.name
      end
    end

    context 'サインインしていない場合' do
      it 'レスポンスコード302を返すこと' do
        get edit_profile_path(user.profile.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        get edit_profile_path(user.profile.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログインしているユーザーとプロフィールのユーザーが同じではない場合' do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
      end

      it 'レスポンスコード302を返すこと' do
        get edit_profile_path(user.profile.id)
        expect(response).to have_http_status(302)
      end

      it 'トップページへリダイレクトすること' do
        get edit_profile_path(user.profile.id)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PUT /profiles/:id' do
    let(:user) { create(:user) }

    context '正常な場合' do
      before do
        sign_in user
      end

      it 'レスポンスコード302を返すこと' do
        put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile) }
        expect(response).to have_http_status(302)
      end

      it 'ログインしているユーザーに関連するプロフィール名を編集すること' do
        expect do
          put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile, name: 'test') }
        end .to change { Profile.last.name }.from(user.profile.name).to('test')
      end

      it '「変更しました」を表示すること' do
        put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile) }
        expect(flash[:notice]).to include '変更しました'
      end

      it '編集したプロフィールページへリダイレクトすること' do
        put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile) }
        expect(response).to redirect_to user.profile
      end
    end

    context 'サインインしていない場合' do
      it 'レスポンスコード302を返すこと' do
        put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile) }
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログインしているユーザーとプロフィールのユーザーが同じではない場合' do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
      end

      it 'レスポンスコード302を返すこと' do
        put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile) }
        expect(response).to have_http_status(302)
      end

      it 'トップページへリダイレクトすること' do
        put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile) }
        expect(response).to redirect_to root_path
      end
    end

    context 'パラメータが不正な場合' do
      before do
        sign_in user
      end

      it 'レスポンスコード422を返すこと' do
        put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile, name: nil) }
        expect(response).to have_http_status(422)
      end

      it 'ログインしているユーザーに関連するプロフィール名を編集しないこと' do
        expect do
          put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile, name: nil) }
        end .to_not change { Profile.last.name }
      end

      it '「エラー」を表示すること' do
        put profile_path(user.profile.id), :params => { :profile => attributes_for(:profile, name: nil) }
        expect(response.body).to include 'エラー'
      end
    end
  end

  describe 'GET /profiles/:id/show_likes' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    before do
      user.likes.create(post_id: post.id)
    end

    context '正常な場合' do
      before do
        sign_in user
      end

      it '正常なレスポンスを返すこと' do
        get show_likes_profile_path(user.profile.id)
        expect(response).to have_http_status(:success)
      end

      it 'プロフィール名を表示すること' do
        get show_likes_profile_path(user.profile.id)
        expect(response.body).to include user.profile.name
      end

      it 'プロフィールに関連したいいねをした投稿名を表示すること' do
        get show_likes_profile_path(user.profile.id)
        expect(response.body).to include post.title
      end
    end

    context 'サインインしていない場合' do
      it 'レスポンスコード302を返すこと' do
        get show_likes_profile_path(user.profile.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        get show_likes_profile_path(user.profile.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
