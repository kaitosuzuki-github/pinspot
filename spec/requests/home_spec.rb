require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe 'GET /' do
    let!(:post) { create(:post) }

    it '正常なレスポンスを返すこと' do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it '投稿名を表示すること' do
      get root_path
      expect(response.body).to include post.title
    end
  end
end
