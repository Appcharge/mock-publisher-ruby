
require 'sinatra'
require './decryptor'
require './auth'
require 'json'

# Read the encryption's KEY and IV from environment variables
iv = ENV['IV']
key = ENV['KEY']
decryptor = AESDecryptor.new(iv, key)

# Read the facebook app's secret from environment variable
$app_secret = ENV['APP_SECRET']

# check that all the parameters are set
if key.nil? || iv.nil? || $app_secret.nil?
  puts "Error: Missing required environment variable"
  puts "required environment variables are KEY, IV, APP_SECRET"
  exit 1
end

# Set webserver port to 8080
set :port, 8080
set :show_exceptions, false
set :raise_errors, false
set :logging, false

# Handle POST requests to /auth
post '/auth' do

    # Set the response type to JSON
    content_type :json

    # Extract the request body as plain text
    request.body.rewind
    request_body = request.body.read

    # Decrypt the request body using AESDecryptor with the provided key and iv
    decryptor = AESDecryptor.new(iv, key)
    decrypted_body = decryptor.decrypt(request_body)
    
    # Extract the 'appId' and 'token' from the decrypted request body
    app_id = decrypted_body["appId"]
    token = decrypted_body["token"]

    # Verify the app_id and token with confirm_fb_login and get the result
    result = confirm_fb_login(app_id, token)

    # If the result is valid, generate and return a PublisherResponse object
    if result[:is_valid]

        publisherResponse = PublisherResponse.new("valid", "", result[:user_id], ["NewUser", "TopSpender"], [
            {
                currency: "diamonds",
                balance: 456,
            },
            {
                currency: "stones",
                balance: 6,
            },
        ])

        return JSON.generate(publisherResponse.to_json)
    
    # If the result is invalid, halt with a 400 error
    elsif
        halt(400)
    end

end

# Error handler controller
error do
    exception = env['sinatra.error']
    status 500
    JSON.generate({ error: exception.message })
end


class PublisherResponse
    attr_accessor :status, :player_profile_image, :publisher_player_id, :player_name, :segments, :balance

    def initialize(status, player_profile_image, publisher_player_id, player_name, balance)
        @status = status
        @player_profile_image = player_profile_image
        @publisher_player_id = publisher_player_id
        @player_name = player_name
        @segments = ['NewUser', 'TopSpender']
        @balance = balance
    end

    def to_json
        {
            :status => @status,
            :playerProfile_image => @player_profile_image,
            :publisherPlayerId => @publisher_player_id,
            :playerName => @player_name,
            :segments => @segments,
            :balance => @balance
        }
    end
    
end
