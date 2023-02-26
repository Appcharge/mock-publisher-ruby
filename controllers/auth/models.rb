class LoginResult
    attr_accessor :is_valid, :user_id

    def initialize(is_valid, user_id)
        @is_valid = is_valid
        @user_id = user_id
    end
end

class LoginResponse
    attr_accessor :status, :player_profile_image, :publisher_player_id, :player_name, :segments, :balance

    def initialize(status, player_profile_image, publisher_player_id, player_name, segments, balance)
        @status = status
        @player_profile_image = player_profile_image
        @publisher_player_id = publisher_player_id
        @player_name = player_name
        @segments = segments
        @balance = balance
    end

    def to_json
        {
            :status => @status,
            :playerProfileImage => @player_profile_image,
            :publisherPlayerId => @publisher_player_id,
            :playerName => @player_name,
            :segments => @segments,
            :balance => @balance
        }
    end
    
end
