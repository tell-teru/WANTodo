require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'

get '/' do
  erb :index
end

get '/signin' do
    
end

post 'signin' do
    
end

get '/signup' do
    
end

post '/signup' do
    
end

get '/signout' do
    
end

get '/user/:id' do
    
end

get '/count/new' do
    
end

post '/count' do
    
end

get '/count/:id' do
    
end

post '/count/:id/plus' do
    
end