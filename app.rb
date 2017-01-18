require 'everypolitician'
require 'sinatra'

require_relative 'lib/document/finder'
require_relative 'lib/helpers/filepaths_helper'
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
  finder = Document::Finder.new(pattern: posts_pattern, baseurl: '/blog/')
  @page = Page::Posts.new(posts: finder.find_all, title: 'Blog')
  erb :posts
end

get '/blog/:slug' do |slug|
  finder = Document::Finder.new(pattern: post_pattern(slug), baseurl: '/blog/')
  @page = Page::Post.new(post: finder.find_single)
  erb :post
end

get '/info/events' do
  finder = Document::Finder.new(pattern: events_pattern, baseurl: '/info/events/')
  @page = Page::Posts.new(posts: finder.find_all, title: 'Events')
  erb :posts
end

get '/info/events/:slug' do |slug|
  finder = Document::Finder.new(pattern: event_pattern(slug), baseurl: '/info/events/')
  @page = Page::Post.new(post: finder.find_single)
  erb :post
end

get '/info/:slug' do |slug|
  finder = Document::Finder.new(pattern: info_pattern(slug), baseurl: '/info/')
  @page = Page::Info.new(static_page: finder.find_single)
  erb :info
end
