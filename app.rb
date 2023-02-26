require 'sinatra'
require 'json'
require_relative 'controllers/index'


# Set webserver port to 8080
set :port, 8080
set :raise_errors, false
set :logging, false
set :show_exceptions, false