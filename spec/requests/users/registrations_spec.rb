require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe 'GET /users/sign_up' do
    it '正常なレスポンスを返すこと' do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /users' do
    context 'ゲストユーザー以外を削除した場合' do
      let(:current_user) { create(:user) }

      before do
        sign_in current_user
      end

      it 'レスポンスコード303を返すこと' do
        delete user_registration_path
        expect(response).to have_http_status(303)
      end
    end

    context 'ゲストユーザーを削除した場合' do
      let(:guest_user) { User.guest }

      before do
        sign_in guest_user
      end

      it 'レスポンスコード302を返すこと' do
        delete user_registration_path
        expect(response).to have_http_status(302)
      end

      it 'ゲストユーザーを削除しないこと' do
        expect { delete(user_registration_path) }.to change { User.count }.by(0)
      end

      it '「ゲストユーザーは削除できません」を表示すること' do
        delete user_registration_path
        expect(flash[:alert]).to eq 'ゲストユーザーは削除できません'
      end

      it 'トップページへリダイレクトすること' do
        delete user_registration_path
        expect(response).to redirect_to root_path
      end
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
