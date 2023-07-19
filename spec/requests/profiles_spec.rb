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
end
