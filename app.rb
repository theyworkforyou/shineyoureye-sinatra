# frozen_string_literal: true
require 'bootstrap-sass'
require 'everypolitician'
require 'sinatra'

require_relative 'lib/featured_person'
require_relative 'lib/document/finder'
require_relative 'lib/ep/people_by_legislature'
require_relative 'lib/helpers/filepaths_helper'
require_relative 'lib/helpers/layout_helper'
require_relative 'lib/helpers/settings_helper'
require_relative 'lib/mapit/geometry'
require_relative 'lib/mapit/wrapper'
require_relative 'lib/membership_csv/people'
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
set :mapit_url, 'http://nigeria.mapit.mysociety.org'
set :twitter_user, 'NGShineyoureye'
set :mapit_user_agent, ENV.fetch('MAPIT_USER_AGENT', nil)

# Create a wrapper for the mappings between the various IDs we have
# to use for areas / places.
mapit_mappings = Mapit::Mappings.new(
  parent_mapping_filenames: [
    'mapit/fed_to_sta_area_ids_mapping.csv',
    'mapit/sen_to_sta_area_ids_mapping.csv'
  ],
  pombola_slugs_to_mapit_ids_filename:
    'mapit/pombola_place_slugs_to_mapit.csv',
  mapit_to_ep_areas_filenames: [
    'mapit/mapit_to_ep_area_ids_mapping_FED.csv',
    'mapit/mapit_to_ep_area_ids_mapping_SEN.csv'
  ]
)

# Create a wrapper that caches MapIt and EveryPolitician area data:
mapit = Mapit::Wrapper.new(
  mapit_mappings: mapit_mappings,
  baseurl: '/place/',
  area_types: %w(FED SEN STA),
  data_directory: 'mapit'
)

# Assemble data on the members of the various legislatures we support:
governors = MembershipCSV::People.new(
  csv_filename: 'morph/nigeria-state-governors.csv',
  mapit: mapit,
  baseurl: '/person/'
)
representatives = EP::PeopleByLegislature.new(
  legislature: settings.index.country('Nigeria').legislature('Representatives'),
  mapit: mapit,
  baseurl: '/person/',
  identifier_scheme: 'shineyoureye'
)
senators = EP::PeopleByLegislature.new(
  legislature: settings.index.country('Nigeria').legislature('Senate'),
  mapit: mapit,
  baseurl: '/person/',
  identifier_scheme: 'shineyoureye'
)

get '/' do
  posts_finder = Document::Finder.new(pattern: posts_pattern, baseurl: '/blog/')
  events_finder = Document::Finder.new(pattern: events_pattern, baseurl: '/info/events/')
  summaries_finder = Document::Finder.new(pattern: summaries_pattern, baseurl: '')
  featured_summaries = summaries_finder.find_featured
  people = [
    PageFragment::FeaturedPerson.new(
      governors.featured_person(featured_summaries),
      'Governors',
      '/position/executive-governor/'
    ),
    PageFragment::FeaturedPerson.new(
      senators.featured_person(featured_summaries),
      'Senators',
      '/position/senator/'
    ),
    PageFragment::FeaturedPerson.new(
      representatives.featured_person(featured_summaries),
      'Representatives',
      '/position/representative/'
    )
  ]
  @page = Page::Homepage.new(posts: posts_finder.find_all, events: events_finder.find_all, featured_people: people)
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
  @page = Page::Places.new(title: 'States', places: mapit.places_of_type('STA'), people_by_legislature: governors)
  erb :places
end

get '/place/is/federal-constituency/' do
  @page = Page::Places.new(
    title: 'Federal Constituencies (Current)',
    places: mapit.places_of_type('FED'),
    people_by_legislature: representatives
  )
  erb :places
end

get '/place/is/senatorial-district/' do
  @page = Page::Places.new(
    title: 'Senatorial Districts (Current)',
    places: mapit.places_of_type('SEN'),
    people_by_legislature: senators
  )
  erb :places
end

get '/place/:slug/' do |slug|
  area = mapit.area_from_pombola_slug(slug)
  pass unless area
  people = {
    'Federal Constituency' => representatives,
    'Senatorial District' => senators,
    'State' => governors
  }
  geometry = Mapit::Geometry.new(
    geojson_url: "#{settings.mapit_url}/area/#{area.id}.geojson",
    geometry_url: "#{settings.mapit_url}/area/#{area.id}/geometry",
    user_agent: settings.mapit_user_agent
  )
  @page = Page::Place.new(place: area, people_by_legislature: people[area.type_name], geometry: geometry)
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

get '/position/executive-governor/' do
  @page = Page::People.new(title: 'Executive Governor', people_by_legislature: governors)
  erb :people
end

get '/person/:id/' do |id|
  pass if representatives.none?(id)
  summary_finder = Document::Finder.new(pattern: summary_pattern(id), baseurl: '')
  @page = Page::Person.new(
    person: representatives.find_single(id),
    position: 'Representative',
    summary_doc: summary_finder.find_or_empty
  )
  erb :person
end

get '/person/:id/' do |id|
  pass if senators.none?(id)
  summary_finder = Document::Finder.new(pattern: summary_pattern(id), baseurl: '')
  @page = Page::Person.new(
    person: senators.find_single(id),
    position: 'Senator',
    summary_doc: summary_finder.find_or_empty
  )
  erb :person
end

get '/person/:id/' do |id|
  pass if governors.none?(id)
  summary_finder = Document::Finder.new(pattern: summary_pattern(id), baseurl: '')
  @page = Page::Person.new(
    person: governors.find_single(id),
    position: 'Governor',
    summary_doc: summary_finder.find_or_empty
  )
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

get '/robots.txt' do
  "User-agent: *\nDisallow:\n"
end

# This route just serves up an empty page that can be used as a Jinja2
# template by services we integrate with this site.
get '/jinja2-template.html' do
  @page = Page::Jinja2.new(title: '{{ title }}')
  erb :jinja2_contents
end

get '/scraper-start-page.html' do
  erb :scraper_start_page, layout: false
end
