require 'pry'

get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/create' do
  title = params[:title]
  body = params[:body]
  tags = params[:tags].split(', ')

  Post.create(:title => title, :body => body)
  post_id = Post.last.id

  tag_index_array = []
  tags.each do |t|
    Tag.find_or_create_by(:name => t)

    tag_index_array << Tag.last.id
  end

  tag_index_array.each do |t|
binding.pry
    Relation.new(:post_id => post_id, :tag_id => t)
  end

  "Success!!"
end
