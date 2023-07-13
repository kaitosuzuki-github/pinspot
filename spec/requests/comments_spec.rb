require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:comment_post) { create(:post) }

  describe 'POST /posts/:post_id/comments' do
    subject do
      post post_comments_path(comment_post.id), :params => params
    end

    context '正常な場合' do
      let(:params) do
        { :comment => { :content => Faker::Lorem.sentence } }
      end

      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'commentを作成すること' do
        expect { subject }.to change { Comment.count }.by(1)
      end

      it 'トップページへリダイレクトすること' do
        subject
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインせずに、コメントをした場合' do
      let(:params) do
        { :comment => { :content => Faker::Lorem.sentence } }
      end

      before do
        subject
      end

      it 'レスポンスコード302を返すこと' do
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'パラメータのデータでcontentの他にuser_idがある場合' do
      let(:params) do
        { :comment => { :content => Faker::Lorem.sentence, :user_id => other_user.id } }
      end

      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'commentを作成すること' do
        expect { subject }.to change { Comment.count }.by(1)
      end

      it '作成されたcommentのuser_idが現在ログインしているユーザーのidであること' do
        subject
        expect(Comment.last.user_id).to eq current_user.id
      end

      it 'トップページへリダイレクトすること' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end
end
