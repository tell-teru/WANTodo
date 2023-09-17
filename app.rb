require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'
# dotsenv
require 'dotenv/load'
# cloudinary
require 'cloudinary'
require 'cloudinary/uploader'
require 'cloudinary/utils'
require 'date'

enable :sessions #セッション機能を使えるようにする

helpers do #ログイン中のユーザーの情報を取得
    def current_user
        User.find_by(id: session[:user])
    end

end

#Cloudinaryを使えるようにする
before do
  
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name = ENV["CLOUD_NAME"]
        config.api_key = ENV["CLOUDINARY_API_KEY"]
        config.api_secret =  ENV["CLOUDINARY_API_SECRET"]
        config.secure = true
    end
    
end

get '/' do
  @title = 'WANTodo ホーム'
  @wants = Want.all
  erb :index
end


# ユーザー登録

get '/signin' do
    erb :sign_in
end

post '/signin' do
    user = User.find_by(name: params[:user])
    puts "user#{user}"
    if user && user.authenticate(params[:password])
         #authenticateメソッド 誤ったパスワード→falseを返す.正しい→そのユーザーを返す
        session[:user] = user.id
    else
        redirect '/signin'
    end
    redirect '/'
end

get '/signup' do
    erb :sign_up
end

post '/signup' do
  if params[:upload_photo]
    image = params[:upload_photo]
    tempfile = image[:tempfile]
    upload = Cloudinary::Uploader.upload(tempfile.path)
    img_url = upload['url']
  else
    img_url = url("images/user_img_nil.png")
  end

  user = User.new(
    name: params[:name],
    password: params[:password],  # パスワードを設定
    password_confirmation: params[:password_confirmation],  # パスワード確認を設定
    img: img_url
  )

  if user.save
    session[:user] = user.id
    redirect '/'
  else
    redirect '/signup'
  end
end


get '/signout' do
    session[:user] = nil
    redirect '/'
end


# 投稿

get '/want/new' do
  @title = 'WANTodo 投稿'
  erb :want_new
end

post '/want/new' do
  Want.create(
    title: params[:title],
    genre_id: params[:genre_id],
    place: params[:place],
    post_group_id: params[:post_group_id]
    )
    
    redirect '/'
end

post '/want/delete/:id' do
end

get '/want/edit/:id' do
  @title = 'WANTodo 投稿編集'
  erb :post_edit
end

post '/want/:id/edit' do
end

post '/done/:id' do
  
end

# ユーザーページ

get '/user/:id' do
    
end

post '/user/:id/done' do
  
end


# グループ登録

get '/group/up' do
    
end

post '/group/up' do
    
end

get '/group/in' do
    
end

post '/group/in' do
    
end
