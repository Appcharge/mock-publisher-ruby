require 'rspec'
require 'rack/test'

ENV['KEY'] = 'your_test_key'

require_relative '../controllers/signature'
require_relative '../controllers/auth/auth_controller'
require_relative '../controllers/auth/auth_methods/facebook_login_service'
require_relative '../controllers/auth/models'

describe AuthController do
  include Rack::Test::Methods

  def app
    AuthController
  end
  
  before(:each) do
    header 'Content-Type', 'application/json'
  end

  context "POST /auth" do
    let(:request_body) do
      {
        authMethod: "facebook",
        appId: "app_id",
        token: "token"
      }.to_json
    end

    it "returns 401 for wrong signature" do
      allow(SignatureService).to receive(:check_signature).and_return(false)
      post '/auth', request_body
      expect(last_response.status).to eq(401)
      expect(last_response.body).to eq("Wrong signature")
    end

    it "returns 400 for bad auth method" do
      allow(SignatureService).to receive(:check_signature).and_return(true)
      wrong_body = request_body.gsub('facebook', 'google')
      post '/auth', wrong_body
      expect(last_response.status).to eq(400)
      expect(last_response.body).to include("bad auth method")
    end

    it "returns 400 for empty login result" do
      allow(SignatureService).to receive(:check_signature).and_return(true)
      allow_any_instance_of(AuthController).to receive(:facebook_login).and_return(nil)
      post '/auth', request_body
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq("empty login result")
    end

    it "returns 400 for login failed" do
      allow(SignatureService).to receive(:check_signature).and_return(true)
      allow_any_instance_of(AuthController).to receive(:facebook_login).and_return(LoginResult.new(false, "123"))
      post '/auth', request_body
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq("login failed")
    end

    it "returns success response for successful login" do
      allow(SignatureService).to receive(:check_signature).and_return(true)
      allow_any_instance_of(AuthController).to receive(:facebook_login).and_return(LoginResult.new(true, "123"))

      post '/auth', request_body
      response_body = JSON.parse(last_response.body)

      expect(last_response.status).to eq(200)
      expect(response_body['status']).to eq('valid')
      expect(response_body['publisherPlayerId']).to eq("123")
    end
  end
end
