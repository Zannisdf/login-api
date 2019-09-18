require 'rails_helper'

def authenticated_header(user)
  token = JsonWebToken.encode({ id: user[:id] })
  { "Content-Type": "application/json", "Authorization": "Bearer #{token}" }
end

RSpec.describe "GET /me", type: :request do
  context 'when authenticated' do
    it 'returns user details' do
      user = User.create(
        email: 'test@tes.ts',
        password: '123456',
        username: 'Lala'
      )
      get '/me', headers: authenticated_header(user)
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response["email"]).to eq(user.email)
      expect(json_response["id"]).to eq(user.id)
    end
  end

  context 'when unauthenticated' do
    it 'returns unauthorized' do
      get '/me', headers: { "Content-Type": "application/json" }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to have_key("errors")
    end
  end

  after(:each) { User.destroy_all }
end