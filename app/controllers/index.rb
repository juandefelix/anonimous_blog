require 'pry'

get '/' do
  erb :index
end

# =============== #
#    U S E R S    #
# =============== #
get '/signup' do
  erb :signup
end

get '/logout' do
  session.clear
  @error = 'Successfully logged out'
  erb :error
end

# renders the template for a user to login
get '/userlogin' do
  erb :login
end
# returns to the home page with a user logged in
get '/login' do
  @email = params[:email]
  user = User.authenticate(@email, params[:password])
  # binding.pry
  if user
    # successfully authenticated; set up session and redirect
    session[:user_id] = user.id
    redirect '/'
  else
    # an error occurred, re-render the sign-in form, displaying an error
    @error = "Invalid email or password."
    erb :error
  end
end

post '/user/new' do
  name = params[:name]
  email = params[:email]
  password = params[:password]
  user = User.create(:name => name,
              :email => email,
              :password => password)
  session[:user_id] = user.id
  redirect '/'
end

get '/user/:id' do
  name =User.find(params[:id]).name
  "#{name}"'s Profile'
end


# =============== #
#    P O S T S    #
# =============== #


post '/create' do

  title = params[:title]
  body = params[:body]
  tags = params[:tags].split(', ')

  begin
    #Creating a Post
    Post.create!(:title => title, :body => body, :user_id => session[:user_id])
    @post_id = Post.last.id

    #Creating a Tag
    tag_index_array = []
    tags.each do |t|
      tag_index_array << Tag.find_or_create_by(:name => t).id
    end

    #Creating the relation
    tag_index_array.each do |t|
    Relation.create!(:post_id => @post_id, :tag_id => t)
    end
    # @my_post
    redirect '/all'
  rescue => e
    # puts e
    redirect "/error/#{e}"
  end
end

get '/error/:error' do
  erb :error
end

get'/post/:id' do

  @id = params[:id]
  @post = Post.find(params[:id].to_i)
  @tags = @post.tags.to_a
# puts @tags
  erb :post
end

get'/all' do
  @all = Post.order(:id)
  erb :all
end

get'/edit/:id' do
  @post = Post.find(params[:id].to_i)
  tags = @post.tags

  erb :edit
end

post '/edit' do
  # puts params['id'].to_i.class
  my_post = Post.find(params['id'].to_i)
  # binding.pry
  my_post.title = params['title']
  my_post.body = params['body']
  my_post.save
  redirect "/post/#{params[:id]}"
end

get '/delete/:id' do
  Post.destroy(params['id'].to_i)
  Relation.where(post_id: 1).each { |s| s.destroy }
  erb :erased
end

get '/find' do
  erb :find
end

post '/find' do

  name = params[:tag]
  redirect "/tag/#{name}" unless Tag.find_by(:name => params[:name]) == nil
  redirect "/error/no%20tag%20found"
end

get '/tag/:name' do
  tag = Tag.find_by(:name => params[:name])
  @all = tag.posts
  erb :tag
end

get'/test/' do
  # params[:post]
  "Success"
end

