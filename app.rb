require 'bootstrap-sass'
require 'everypolitician'
require 'sinatra'

require_relative 'lib/document/finder'
require_relative 'lib/ep/people_by_legislature'
require_relative 'lib/helpers/filepaths_helper'
require_relative 'lib/helpers/layout_helper'
require_relative 'lib/helpers/settings_helper'
require_relative 'lib/mapit/wrapper'
require_relative 'lib/page/homepage'
require_relative 'lib/page/info'
require_relative 'lib/page/jinja2'
require_relative 'lib/page/place'
require_relative 'lib/page/places'
require_relative 'lib/page/people'
require_relative 'lib/page/person'
require_relative 'lib/page/post'
require_relative 'lib/page/posts'

set :content_dir, File.join(__dir__, 'prose')
set :datasource, ENV.fetch('DATASOURCE', 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json')
set :index, EveryPolitician::Index.new(index_url: settings.datasource)
set :mapit_url, 'http://nigeria.mapit.mysociety.org/areas/'
set :twitter_user, 'NGShineyoureye'

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
  @page = Page::Places.new(title: 'Federal Constituencies (Current)', places: mapit.federal_constituencies, people_by_legislature: representatives)
  erb :places
end

get '/place/is/senatorial-district/' do
  @page = Page::Places.new(title: 'Senatorial District (Current)', places: mapit.senatorial_districts, people_by_legislature: senators)
  erb :places
end

get '/place/:slug/' do |slug|
  place = mapit.area_from_pombola_slug(slug)
  @page = Page::Place.new(place: place, people_by_legislature: representatives, people_path: '/people/')
  erb :place_overview
end

get '/position/representative/' do
  @page = Page::People.new(title: 'Federal Representative', people_by_legislature: representatives)
  erb :people
end

get '/position/senator/' do
  @page = Page::People.new(title: 'Senator', people_by_legislature: senators)
  erb :people
end

get '/person/:id/' do |id|
  pass if representatives.none?(id)
  @page = Page::Person.new(person: representatives.find_single(id), position: 'Representative')
  erb :person
end

get '/person/:id/' do |id|
  pass if senators.none?(id)
  @page = Page::Person.new(person: senators.find_single(id), position: 'Senator')
  erb :person
end

get '/fonts/bootstrap/:filename' do |filename|
  send_file(File.join(Bootstrap.fonts_path, 'bootstrap', filename))
end

get '/javascripts/bootstrap/:filename' do |filename|
  send_file(File.join(Bootstrap.javascripts_path, filename))
end

# This route just serves up an empty page that can be used as a Jinja2
# template by services we integrate with this site.
get '/jinja2-template.html' do
  @page = Page::Jinja2.new(title: '{{ title }}')
  erb :jinja2_contents
end

get '/scraper-start-page.html' do
  erb :scraper_start_page, :layout => false
end

def representatives
  EP::PeopleByLegislature.new(legislature: house, mapit: mapit, baseurl: '/person/')
end

def senators
  EP::PeopleByLegislature.new(legislature: senate, mapit: mapit, baseurl: '/person/')
end

def mapit
  Mapit::Wrapper.new(mapit_url: mapit_url, mapit_mappings: mappings, baseurl: '/place/')
end
