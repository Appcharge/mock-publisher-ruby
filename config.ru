require 'sinatra'
require_relative 'app'


use Rack::CommonLogger

run App