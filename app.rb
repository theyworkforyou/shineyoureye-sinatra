require 'everypolitician'
require 'sinatra'

require_relative 'lib/document/markdown_with_frontmatter'
require_relative 'lib/helpers/constants_helper'
require_relative 'lib/page/info'
require_relative 'lib/page/posts'
require_relative 'lib/page/post'

set :datasource, ENV.fetch('DATASOURCE', 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json')
set :index, EveryPolitician::Index.new(index_url: settings.datasource)
set :content_dir, File.join(__dir__, 'prose')

get '/' do
  erb :homepage
end

get '/places/' do
  @country = settings.index.country('Nigeria')
  erb :places
end

get '/blog/' do
  @page = Page::Posts.new(directory: posts_dir)
  erb :posts
end

get '/blog/:slug' do |slug|
  @page = Page::Post.new(directory: posts_dir, slug: slug)
  raise Sinatra::NotFound if @page.none?
  raise "Multiple posts matched '#{slug}'" if @page.multiple?
  erb :post
end

get '/info/:slug' do |slug|
  @page = Page::Info.new(directory: info_dir, slug: slug)
  raise Sinatra::NotFound if @page.none?
  erb :info
end
