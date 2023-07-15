require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe 'GET /users/sign_up' do
    it '正常なレスポンスを返すこと' do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end
end
