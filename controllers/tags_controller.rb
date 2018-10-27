require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/tag.rb')
also_reload('../models/*')

get '/tags' do
  @tag = Tag.all()
  erb ( :"tags/index" )
end

get '/tags/:id' do
  @tag = Tag.find(params['id'].to-i)
  erb(:"tags/show")
end
    