require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  describe 'POST /users/guest_sign_in' do
    it 'レスポンスコード302を返すこと' do
      post users_guest_sign_in_path
      expect(response).to have_http_status(302)
    end

    it 'ゲストユーザーとしてサインインすること' do
      post(users_guest_sign_in_path)
      expect(session.present?).to be_truthy
    end

    it '「ゲストユーザーとしてログインしました」を表示すること' do
      post(users_guest_sign_in_path)

      expect(flash[:notice]).to include 'ゲストユーザーとしてログインしました'
    end

    it 'トップページヘリダイレクトすること' do
      post users_guest_sign_in_path
      expect(response).to redirect_to root_path
    end
  end
end
