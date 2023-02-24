require 'http'

def confirm_fb_login(app_id, token)
    debug_token_url = "https://graph.facebook.com/debug_token"
    input_token_param = "input_token=#{token}"
    access_token_param = "access_token=#{app_id}|#{$app_secret}"
    url_params = "#{input_token_param}&#{access_token_param}"
    url = "#{debug_token_url}?#{url_params}"
    
    response = HTTP.get(url)
    
    if response.code == 200

        response_obj = JSON.parse(response.body)
        is_valid = response_obj["data"]["is_valid"]
        user_id = response_obj["data"]["user_id"]
        
        return {
            :is_valid => is_valid,
            :user_id => user_id
        }
    end

    return {
        :is_valid => false,
        :user_id => "0"
    }
end
