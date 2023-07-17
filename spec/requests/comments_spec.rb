require 'rails_helper'

RSpec.describe "Comments", type: :request do
  describe 'POST /posts/:post_id/comments' do
    let(:current_user) { create(:user) }
    let(:comment_post) { create(:post) }

    context '正常な場合' do
      let(:params) do
        { :comment => { :content => Faker::Lorem.sentence } }
      end

      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        post post_comments_path(comment_post.id), :params => params
        expect(response).to have_http_status(302)
      end

      it 'commentを作成すること' do
        expect {  post post_comments_path(comment_post.id), :params => params }.to change { Comment.count }.by(1)
      end

      it 'トップページへリダイレクトすること' do
        post post_comments_path(comment_post.id), :params => params
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインせずに、コメントをした場合' do
      let(:params) do
        { :comment => { :content => Faker::Lorem.sentence } }
      end

      it 'レスポンスコード302を返すこと' do
        post post_comments_path(comment_post.id), :params => params
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        post post_comments_path(comment_post.id), :params => params
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'パラメータのデータでcontentの他にuser_idがある場合' do
      let(:other_user) { create(:user) }

      let(:params) do
        { :comment => { :content => Faker::Lorem.sentence, :user_id => other_user.id } }
      end

      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        post post_comments_path(comment_post.id), :params => params
        expect(response).to have_http_status(302)
      end

      it 'commentを作成すること' do
        expect { post post_comments_path(comment_post.id), :params => params }.to change { Comment.count }.by(1)
      end

      it '作成されたcommentのuser_idが現在ログインしているユーザーのidであること' do
        post post_comments_path(comment_post.id), :params => params
        expect(Comment.last.user_id).to eq current_user.id
      end

      it 'トップページへリダイレクトすること' do
        post post_comments_path(comment_post.id), :params => params
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    let!(:comment) { create(:comment) }

    context '正常な場合' do
      before do
        sign_in comment.user
      end

      it 'レスポンスコード302を返すこと' do
        delete post_comment_path(comment.post.id, comment.id)
        expect(response).to have_http_status(302)
      end

      it 'commentを削除すること' do
        expect { delete post_comment_path(comment.post.id, comment.id) }.to change { Comment.count }.by(-1)
      end

      it 'トップページへリダイレクトすること' do
        delete post_comment_path(comment.post.id, comment.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインせずに、コメントを削除した場合' do
      it 'レスポンスコード302を返すこと' do
        delete post_comment_path(comment.post.id, comment.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        delete post_comment_path(comment.post.id, comment.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context '存在しないコメントを削除した場合' do
      before do
        sign_in comment.user
      end

      it '例外処理が発生すること' do
        expect { delete post_comment_path(comment.post.id, 0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'コメントを削除したのが、現在ログインしているユーザーと異なる場合' do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
      end

      it 'レスポンスコード302を返すこと' do
        delete post_comment_path(comment.post.id, comment.id)
        expect(response).to have_http_status(302)
      end

      it 'commentを削除しないこと' do
        expect { delete post_comment_path(comment.post.id, comment.id) }.to change { Comment.count }.by(0)
      end

      it 'トップページへリダイレクトすること' do
        delete post_comment_path(comment.post.id, comment.id)
        expect(response).to redirect_to root_path
      end
    end
  end
end
