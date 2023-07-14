require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe 'GET /' do
    let!(:post) { create(:post) }
    before do
      get root_path
    end

    it '正常なレスポンスを返すこと' do
      expect(response).to have_http_status(:success)
    end

    it '投稿名を表示すること' do
      expect(response.body).to include post.title
    end
  end
end
