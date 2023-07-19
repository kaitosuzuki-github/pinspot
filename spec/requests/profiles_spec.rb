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
end
