require 'everypolitician'
require 'sinatra'

require_relative 'lib/document/finder'
require_relative 'lib/helpers/breadcrumbs_helper'
require_relative 'lib/helpers/filepaths_helper'
require_relative 'lib/helpers/layout_helper'
require_relative 'lib/page/homepage'
require_relative 'lib/page/info'
require_relative 'lib/page/posts'
require_relative 'lib/page/post'

set :datasource, ENV.fetch('DATASOURCE', 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json')
set :index, EveryPolitician::Index.new(index_url: settings.datasource)
set :content_dir, File.join(__dir__, 'prose')
# The breadcrumb map should not have trailing slashes (except for the
# root, '/'). If a prefix maps to nil, a breadcrumb won't be generated
# for that prefix.
set :breadcrumbs,
    '/' => 'Home',
    '/blog' => 'Blog',
    '/info' => nil,
    '/info/events' => 'Events'

get '/' do
  posts_finder = Document::Finder.new(pattern: posts_pattern, baseurl: '/blog/')
  events_finder = Document::Finder.new(pattern: events_pattern, baseurl: '/info/events/')
  @page = Page::Homepage.new(posts: posts_finder.find_all, events: events_finder.find_all)
  erb :homepage
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
