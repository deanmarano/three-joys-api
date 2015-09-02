require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /session" do
    it "requires an authorization header" do
      get v1_session_path
      expect(response).to have_http_status(422)
      body = JSON.parse(response.body)
      expect(body['code']). to eq 'validation_error'
      expect(body['message']). to eq 'An authorization header with a JWT is required'
      expect(body['fields']). to eq 'headers[Authorization]'
    end

    it "returns a session if one exists" do
      user = User.create(name: "Deano", email: "dean.marano@gmail.com")
      session = Session.create!(user: user)
      get v1_session_path, nil, {Authorization: session.token}
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)
      expect(body['token']).to be_present
      token = JSON.parse(Base64.decode64(body['token'].split('.')[1]))
      expect(token['name']). to eq 'Deano'
      expect(token['email']). to eq 'dean.marano@gmail.com'
      expect(token['id']). to eq user.id
    end
  end
  describe "POST /session" do
    let(:user) { User.create(name: "Deano", email: "dean.marano@gmail.com", password: 'rhinos', password_confirmation: 'rhinos') }
    it "allows login with an email address which sends a one time login email" do
      expect do
      user
      post v1_session_path, {session: {email: 'dean.marano@gmail.com'}}
      expect(response).to have_http_status(204)
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "allows login with an email address and password" do
      user
      post v1_session_path, {session: {email: 'dean.marano@gmail.com', password: 'rhinos'}}
      expect(response).to have_http_status(201)
      body = JSON.parse(response.body)
      expect(body['token']).to be_present
      token = JSON.parse(Base64.decode64(body['token'].split('.')[1]))
      expect(token['name']). to eq 'Deano'
      expect(token['email']). to eq 'dean.marano@gmail.com'
      expect(token['id']). to eq user.id
    end

    it "allows login with a one time use token" do
      session = Session.create!(user: user)
      post v1_session_path, {session: {token: session.token}}
      expect(response).to have_http_status(201)
      body = JSON.parse(response.body)
      expect(body['token']).to be_present
      token = JSON.parse(Base64.decode64(body['token'].split('.')[1]))
      expect(token['name']). to eq 'Deano'
      expect(token['email']). to eq 'dean.marano@gmail.com'
      expect(token['id']). to eq user.id
      expect(Session.find_by(id: session.id)).to be_nil
    end
  end
end
