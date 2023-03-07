require 'sinatra/base'
require_relative 'auth_methods/facebook_login_service'
require_relative 'models'
class AuthController < Sinatra::Base
    # Handle POST requests to /auth
    post '/auth' do

        # Set the response type to JSON
        content_type :json

        # Extract the request body as plain text
        request.body.rewind
        request_body = request.body.read

        # Decrypt the request body using AESDecryptor with the provided key and iv
        decrypted_body = Decryptor.decrypt(request_body)

        auth_type = decrypted_body["authType"]

        # authentication implementations
        result = nil
        case auth_type
        when "facebook"
            app_id = decrypted_body["appId"]
            token = decrypted_body["token"]
            
            # Verify the app_id and token with confirm_fb_login and get the result
            result = facebook_login(app_id, token)
        else
            halt(400, "bad auth type: #{auth_type}")
            return
        end

        if result.nil?
            halt(400, "empty login result")
        end

        # If the result is valid, generate and return a PublisherResponse object
        if result.is_valid

            login_response = LoginResponse.new("valid", "", result.user_id, ["NewUser", "TopSpender"],
                ['NewUser', 'TopSpender'], [
                {
                    currency: "diamonds",
                    balance: 456,
                },
                {
                    currency: "stones",
                    balance: 6,
                },
            ])

            json_response = JSON.generate(login_response.to_json)

            return json_response
        
        # If the result is invalid, halt with a 400 error
        else
            halt(400, "login failed")
        end

    end

    
end

