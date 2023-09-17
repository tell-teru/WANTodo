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
  
  # # 投稿したuserのimgを取得
  # @want = Want.find(params[:id])
  # post_user_id = want.post_user_id
  # user = User.find_by(id: post_user_id)
  # if user
  #   img_url = user.img
  # else
  #   # post_user_idに対応するユーザーが存在しない場合の処理をここに追加
  #   img_url = nil
  # end
  
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
    post_group_id: params[:post_group_id],
    
    post_user_id: current_user.id
  )
    
    redirect '/'
end

post '/want/delete/:id' do
  want = Want.find(params[:id])
  want.delete
  redirect '/'
end

get '/want/edit/:id' do
  @title = 'WANTodo 投稿編集'
  
  @want = Want.find(params[:id])
  erb :want_edit
end

post '/want/edit/:id' do
  want = Want.find(params[:id])
  
  want.title = params[:title]
  want.genre_id = params[:genre_id]
  want.place = params[:place]
  want.post_group_id = params[:post_group_id]
  
  want.save
  redirect '/'
end

post '/done/:id' do
  
end

# ユーザーページ

get '/user/:id' do
    
end

post '/user/:id/done' do
  
end


# グループ登録

# get '/group/up' do
#     erb :group_up
# end

# post '/group/up' do
#   group = Group.new(
#     name: params[:name],
#     password: params[:password],  # パスワードを設定
#     password_confirmation: params[:password_confirmation],  # パスワード確認を設定
#   )

#   redirect '/'
# end

# get '/group/in' do
#     erb :group_in
# end

# post '/group/in' do
#     group = Group.find_by(name: params[:user])
    
#     puts "user#{user}"
#     if group && group.authenticate(params[:password])
#         #authenticateメソッド 誤ったパスワード→falseを返す.正しい→そのユーザーを返す
#         session[:user] = user.id
#     else
#         redirect '/signin'
#     end
#     redirect '/'
# end
