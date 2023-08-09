require 'json'
require_relative '../signature'
require_relative 'models'

class PlayerController < Sinatra::Base
    # Handle POST requests to /auth
    post '/updateBalance' do

        # Set the response type to JSON
        content_type :json

        # Extract the request body as plain text
        request.body.rewind
        request_body = request.body.read

        # Decrypt the request body using AESDecryptor with the provided key and iv
        if SignatureService.check_signature(request_body, request.env["HTTP_SIGNATURE"])
            body = JSON.parse(request_body)
        else
            halt(401, "Wrong signature")
        end
        
        products = body["products"].map do |product_hash|
            Product.new(product_hash["amount"], product_hash["sku"], product_hash["name"])
        end
        
        payload = PublisherPayload.new(body)

        # TODO
        # Here goes your piece of code that is responsible for handling player update balance requests coming from appcharge systems
        
        response = PlayerUpdateBalanceResponse.new("123", Time.now.utc.iso8601)
        return JSON.generate(response.to_json)
    end

    error do
        puts "error"
        exception = env['sinatra.error']
        status 503
        JSON.generate({ error: exception.message })
    end
end