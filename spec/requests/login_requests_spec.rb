require 'rails_helper'

RSpec.describe "POST /auth/login", type: :request do
  user = User.create(email: 'test@te.st', password: '123456', username: 'Lala')
  headers = { "Content-Type": "application/json" }
  ENDPOINT = '/auth/login'
  it "returns unauthorized with wrong credentials" do
    credentials = '{ "email": "user@us.er", "password": "123456" }'
    post ENDPOINT, params: credentials, headers: headers

    expect(response).to have_http_status(:unauthorized)

    credentials = '{ "email": "test@te.st", "password": "123455" }'
    post ENDPOINT, params: credentials, headers: headers

    expect(response).to have_http_status(:unauthorized)
  end

  it "returns a token when logged in" do
    credentials = '{ "email": "test@te.st", "password": "123456" }'
    post ENDPOINT, params: credentials, headers: headers

    expect(response).to have_http_status(:ok)

    json_response = JSON.parse(response.body)
    expect(json_response).to have_key("token")
    expect(json_response["username"]).to eq(user.username)
  end

  after(:each) { User.destroy_all }
end