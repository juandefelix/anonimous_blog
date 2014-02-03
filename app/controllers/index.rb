require 'pry'

get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/create' do

  title = params[:title]
  body = params[:body]
  tags = params[:tags].split(', ')

  begin
    #Creating a Post
    Post.create!(:title => title, :body => body)
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
  redirect "/all"
end

get '/delete/:id' do
  Post.destroy(params['id'].to_i)
  Relation.where(post_id: 1).each { |s| s.destroy }
  erb :erased
  # redirect '/all'
end

get '/find' do
  erb :find
end

post '/find' do
"Success"
  name = params[:tag]
  redirect "/tag/#{name}"
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

