require 'everypolitician'
require 'sinatra'
require 'bootstrap-sass'

require_relative 'lib/document/finder'
require_relative 'lib/helpers/filepaths_helper'
require_relative 'lib/helpers/layout_helper'
require_relative 'lib/mapit/mappings'
require_relative 'lib/mapit/wrapper'
require_relative 'lib/page/homepage'
require_relative 'lib/page/info'
require_relative 'lib/page/places'
require_relative 'lib/page/posts'
require_relative 'lib/page/post'

set :datasource, ENV.fetch('DATASOURCE', 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json')
set :index, EveryPolitician::Index.new(index_url: settings.datasource)
set :content_dir, File.join(__dir__, 'prose')
set :mapit_url, 'http://nigeria.mapit.mysociety.org/areas/'

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
  pass if finder.none?
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
  pass if finder.none?
  @page = Page::Post.new(post: finder.find_single)
  erb :post
end

get '/info/:slug' do |slug|
  finder = Document::Finder.new(pattern: info_pattern(slug), baseurl: '/info/')
  pass if finder.none?
  @page = Page::Info.new(static_page: finder.find_single)
  erb :info
end

get '/place/is/federal-constituency/' do
  mappings = Mapit::Mappings.new(
    fed_to_sta_ids_mapping_filename: './mapit/fed_to_sta_area_ids_mapping.csv',
    pombola_slugs_to_mapit_ids_filename: './mapit/pombola_place_slugs_to_mapit.csv',
    mapit_to_ep_areas_filename: './mapit/mapit_to_ep_area_ids_mapping.csv'
  )
  mapit = Mapit::Wrapper.new(mapit_url: settings.mapit_url, mapit_mappings: mappings, baseurl: '/place/')
  @page = Page::Places.new('Federal Constituencies (Current)', mapit.federal_constituencies)
  erb :federal
end

get '/fonts/bootstrap/:filename' do |filename|
  send_file(File.join(Bootstrap.fonts_path, 'bootstrap', filename))
end

get '/javascripts/bootstrap/:filename' do |filename|
  send_file(File.join(Bootstrap.javascripts_path, filename))
end
