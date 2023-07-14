require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  describe 'GET /contacts/new' do
    before do
      get new_contact_path
    end

    it '正常なレスポンスを返すこと' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /contacts' do
    subject do
      post contacts_path, :params => params
    end

    context '正常な場合' do
      let(:params) do
        { :contact => { :email => Faker::Internet.email, :subject => Faker::Lorem.sentence, :message => Faker::Lorem.paragraph } }
      end

      it 'レスポンスコード302を返すこと' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'contactを作成すること' do
        expect { subject }.to change { Contact.count }.by(1)
      end

      it 'お問い合わせメールを送ること' do
        expect { subject }.to change { ActionMailer::Base.deliveries.size }.by(1)
      end

      it 'flash[:notice]で「お問い合わせを受け付けました」を表示すること' do
        subject
        expect(flash[:notice]).to eq 'お問い合わせを受け付けました'
      end

      it 'トップページへリダイレクトすること' do
        subject
        expect(response).to redirect_to root_path
      end
    end

    context 'パラメータが不正でcontactを保存できなかった場合' do
      let(:params) do
        { :contact => { :email => nil, :subject => nil, :message => nil } }
      end

      it 'レスポンスコード422を返すこと' do
        subject
        expect(response).to have_http_status(422)
      end

      it 'contactを作成しないこと' do
        expect { subject }.to change { Contact.count }.by(0)
      end

      it 'お問い合わせメールを送らないこと' do
        expect { subject }.to change { ActionMailer::Base.deliveries.size }.by(0)
      end

      it 'エラーを表示すること' do
        subject
        expect(response.body).to include 'エラー'
      end
    end

    context 'パラメータのハッシュにcontactがない場合' do
      let(:params) do
        { :test => { :email => Faker::Internet.email, :subject => Faker::Lorem.sentence, :message => Faker::Lorem.paragraph } }
      end

      it 'パラメータのエラーが発生すること' do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end
