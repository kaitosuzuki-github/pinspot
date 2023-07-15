require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe 'GET /users/sign_up' do
    it '正常なレスポンスを返すこと' do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /users/show' do
    context '正常な場合' do
      let(:current_user) { create(:user) }
      let!(:current_profile) { create(:profile, user: current_user) }

      before do
        sign_in current_user
      end

      it '正常なレスポンスを返すこと' do
        get users_show_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'サインインしていない場合' do
      it 'レスポンスコード302を返すこと' do
        get users_show_path
        expect(response).to have_http_status(302)
      end

      it '「ログインもしくはアカウント登録してください」を表示すること' do
        get users_show_path
        expect(flash[:alert]).to eq 'ログインもしくはアカウント登録してください'
      end

      it 'サインインページへリダイレクトすること' do
        get users_show_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
