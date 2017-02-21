# frozen_string_literal: true
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

# Create a wrapper for the mappings between the various IDs we have
# to use for areas / places.
mapit_mappings = Mapit::Mappings.new(
  fed_to_sta_ids_mapping_filename:
    './mapit/fed_to_sta_area_ids_mapping.csv',
  pombola_slugs_to_mapit_ids_filename:
    './mapit/pombola_place_slugs_to_mapit.csv',
  mapit_to_ep_areas_fed_filename:
    './mapit/mapit_to_ep_area_ids_mapping_FED.csv',
  mapit_to_ep_areas_sen_filename:
    './mapit/mapit_to_ep_area_ids_mapping_SEN.csv'
)

# Create a wrapper that caches MapIt and EveryPolitician area data:
mapit = Mapit::Wrapper.new(
  mapit_url: settings.mapit_url,
  mapit_mappings: mapit_mappings,
  baseurl: '/place/'
)

# Assemble data on the members of the various legislatures we support:
governors = nil
representatives = EP::PeopleByLegislature.new(
  legislature: settings.index.country('Nigeria').legislature('Representatives'),
  mapit: mapit,
  baseurl: '/person/'
)
senators = EP::PeopleByLegislature.new(
  legislature: settings.index.country('Nigeria').legislature('Senate'),
  mapit: mapit,
  baseurl: '/person/'
)

# Now we define the routes:

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

get '/place/is/state/' do
  @page = Page::Places.new(title: 'States', places: mapit.states, people_by_legislature: governors)
  erb :places
end

get '/place/is/federal-constituency/' do
  @page = Page::Places.new(title: 'Federal Constituencies (Current)', places: mapit.federal_constituencies, people_by_legislature: representatives)
  erb :places
end

get '/place/is/senatorial-district/' do
  @page = Page::Places.new(title: 'Senatorial Districts (Current)', places: mapit.senatorial_districts, people_by_legislature: senators)
  erb :places
end

get '/place/:slug/' do |slug|
  constituency = mapit.area_from_pombola_slug(slug)
  pass if representatives.none_by_mapit_area?(constituency.id)
  @page = Page::Place.new(place: constituency, people_by_legislature: representatives, people_path: '/people/')
  erb :place
end

get '/place/:slug/' do |slug|
  district = mapit.area_from_pombola_slug(slug)
  pass if senators.none_by_mapit_area?(district.id)
  @page = Page::Place.new(place: district, people_by_legislature: senators, people_path: '/people/')
  erb :place
end

get '/place/:slug/' do |slug|
  state = mapit.area_from_pombola_slug(slug)
  @page = Page::Place.new(place: state, people_by_legislature: representatives, people_path: '/people/')
  erb :place
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

Search = Struct.new(:title)
get '/search/' do
  @page = Search.new('Search')
  erb :search
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
