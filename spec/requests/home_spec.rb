require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe 'GET /' do
    let!(:posts) { create_list(:post, 2) }

    it '正常なレスポンスを返すこと' do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it 'すべての投稿名を表示すること' do
      get root_path
      expect(response.body).to include posts[0].title
      expect(response.body).to include posts[1].title
    end
  end
end
