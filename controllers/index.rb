require 'sinatra'

require_relative 'auth/auth_controller'
require_relative 'player/player_controller'

use AuthController
use PlayerController