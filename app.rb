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


before do
  #Cloudinaryを使えるようにする
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name = ENV["CLOUD_NAME"]
        config.api_key = ENV["CLOUDINARY_API_KEY"]
        config.api_secret =  ENV["CLOUDINARY_API_SECRET"]
        config.secure = true
    end
    
    @wants = Want.all

    Genre.create([
      {name: "映画", img: 'img/movie.png'},
      {name: "展覧会", img: 'img/exhibition.png'},
      {name: "体験", img: 'img/taiken.png'},
      {name: "ご飯", img: 'img/meal.png'},
      {name: "テーマパーク", img: 'img/earth.png'},
      {name: "その他", img: 'img/others.png'}
    ])
    
    unless Group.exists?(name: "全体")
      Group.create(
        name: "全体",
        password: "all",
        password_confirmation: "all"
      )
  end
end

get '/' do
  @title = 'WANTodo ホーム'
  @wants = Want.all
  
  erb :index
end


# ユーザー登録

get '/signin' do
  @title = 'WANTodo ログイン'
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
  @title = 'WANTodo 新規登録'
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
    Part.create(
      user_id: current_user.id,
      group_id: 1
    )
  
    redirect '/'
  else
    redirect '/signup'
  end
end


#postじゃないか？-><a>タグつかう時はget
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
    
  # end_dateの方が後の日付であるかを確認
  # if start_date <= end_date -> バリデーションで実装
    
  Want.create(
    title: params[:title],
    place: params[:place],
    genre_id: params[:genre_id],
    group_id: params[:group_id],
    done: false,
    
    start_date: params[:start_date],
    end_date: params[:end_date],
    
    user_id: current_user.id
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
  want.group_id = params[:group_id]
  
  want.start_date = params[:start_date]
  want.end_date = params[:end_date]
  
  want.save
  redirect '/'
end

get '/want/done/:id' do
    want = Want.find(params[:id])
    want.done = params[:isChecked] == "true" # チェックボックスの状態に応じて設定
    want.save
    
    redirect '/'
end

# ユーザーページ

get '/user/:id' do
  @title = 'WANTodo マイページ'
  erb :user_page
end

post '/user/:id/done' do
  
end


# グループ登録

get '/group/up' do
    erb :group_up
end

post '/group/up' do
  Group.create(
    name: params[:name],
    password: params[:password],  # パスワードを設定
    password_confirmation: params[:password_confirmation]  # パスワード確認を設定
  )
  
  group = Group.find_by(name: params[:name])
  Part.create(
    user_id: current_user.id,
    group_id: group.id 
  )

  redirect '/'
end

get '/group/in' do
    erb :group_in
end

post '/group/in' do
    group = Group.find_by(name: params[:user])
    
    # puts "user#{user}"
    if group && group.authenticate(params[:password])
        #authenticateメソッド 誤ったパスワード→falseを返す.正しい→そのユーザーを返す
        # session[:user] = user.id
        
        Part.create(
          user_id: current_user.id,
          group_id: group.id 
        )
    else
        redirect '/group/in'
    end
    redirect '/'
end

# グループページ

get '/group/page/:id' do
  @title = 'WANTodo グループ投稿'
  erb :group_page
end

post '/user/:id/done' do
  
end
