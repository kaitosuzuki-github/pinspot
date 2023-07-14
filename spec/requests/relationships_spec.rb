require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe 'POST /users/:user_id/relationships' do
    let(:current_user) { create(:user) }
    let(:follow_user) { create(:user) }

    context '正常な場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        post user_relationships_path(follow_user.id)
        expect(response).to have_http_status(302)
      end

      it 'フォローすること' do
        expect { post user_relationships_path(follow_user.id) }.to change { current_user.relationships.count }.by(1)
        expect(current_user.relationships.last.follow_id).to eq follow_user.id
      end

      it 'トップページへリダイレクトすること' do
        post user_relationships_path(follow_user.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインしていない場合' do
      it 'レスポンスコード302を返すこと' do
        post user_relationships_path(follow_user.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        post user_relationships_path(follow_user.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context '自分自身をフォローする場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        post user_relationships_path(current_user.id)
        expect(response).to have_http_status(302)
      end

      it 'フォローしないこと' do
        expect { post user_relationships_path(current_user.id) }.to change { current_user.relationships.count }.by(0)
      end

      it 'トップページへリダイレクトすること' do
        post user_relationships_path(current_user.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'すでにフォローしている場合' do
      before do
        sign_in current_user
        current_user.follow(follow_user.id)
      end

      it 'レスポンスコード302を返すこと' do
        post user_relationships_path(follow_user.id)
        expect(response).to have_http_status(302)
      end

      it 'フォローしないこと' do
        expect { post user_relationships_path(follow_user.id) }.to change { current_user.relationships.count }.by(0)
      end

      it 'トップページへリダイレクトすること' do
        post user_relationships_path(follow_user.id)
        expect(response).to redirect_to root_path
      end
    end

    context '存在しないユーザーをフォローする場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        post user_relationships_path(0)
        expect(response).to have_http_status(302)
      end

      it 'フォローしないこと' do
        expect { post user_relationships_path(0) }.to change { current_user.relationships.count }.by(0)
      end

      it 'トップページへリダイレクトすること' do
        post user_relationships_path(0)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE /users/:user_id/relationships' do
    let(:current_user) { create(:user) }
    let(:follow_user) { create(:user) }

    context '正常な場合' do
      before do
        sign_in current_user
        current_user.follow(follow_user.id)
      end

      it 'レスポンスコード302を返すこと' do
        delete user_relationships_path(follow_user.id)
        expect(response).to have_http_status(302)
      end

      it 'フォローを解除すること' do
        expect { delete user_relationships_path(follow_user.id) }.to change { current_user.relationships.count }.by(-1)
      end

      it 'トップページにリダイレクトすること' do
        delete user_relationships_path(follow_user.id)
        expect(response).to redirect_to root_path
      end
    end

    context 'サインインしていない場合' do
      before do
        current_user.follow(follow_user.id)
      end

      it 'レスポンスコード302を返すこと' do
        delete user_relationships_path(follow_user.id)
        expect(response).to have_http_status(302)
      end

      it 'サインインページへリダイレクトすること' do
        delete user_relationships_path(follow_user.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'まだフォローしていない場合' do
      before do
        sign_in current_user
      end

      it 'レスポンスコード302を返すこと' do
        delete user_relationships_path(follow_user.id)
        expect(response).to have_http_status(302)
      end

      it 'フォローを解除しないこと' do
        expect { delete user_relationships_path(follow_user.id) }.to change { current_user.relationships.count }.by(0)
      end

      it 'トップページにリダイレクトすること' do
        delete user_relationships_path(follow_user.id)
        expect(response).to redirect_to root_path
      end
    end
  end
end
