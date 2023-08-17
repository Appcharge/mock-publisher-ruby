require 'rspec'
require 'rack/test'

ENV['KEY'] = 'your_test_key'

require_relative '../controllers/signature'
require_relative '../controllers/player/player_controller'

describe PlayerController do
  include Rack::Test::Methods

  def app
    PlayerController
  end

  before(:each) do
    header 'Content-Type', 'application/json'
  end

  context "POST /updateBalance" do
    let(:request_body) do
      {
        appChargePaymentId: "charge_id",
        purchaseDateAndTimeUtc: Time.now.utc.iso8601,
        gameId: "game123",
        playerId: "player123",
        bundleName: "bundle_name",
        bundleId: "bundle_id",
        sku: "sku123",
        priceInCents: 100,
        priceInDollar: 1.00,
        currency: "USD",
        action: "purchase",
        actionStatus: "completed",
        products: [
          { amount: 1, sku: "sku123", name: "product_name" }
        ],
        tax: 0,
        subTotal: 1.00
      }.to_json
    end

    it "returns 401 for wrong signature" do
      allow(SignatureService).to receive(:check_signature).and_return(false)
      post '/updateBalance', request_body
      expect(last_response.status).to eq(401)
      expect(last_response.body).to eq("Wrong signature")
    end

    it "returns success response for proper signature and valid request" do
      allow(SignatureService).to receive(:check_signature).and_return(true)
      post '/updateBalance', request_body

      response_body = JSON.parse(last_response.body)

      expect(last_response.status).to eq(200)
      expect(response_body['publisherPurchaseId']).to eq("123")
    end
  end
end
