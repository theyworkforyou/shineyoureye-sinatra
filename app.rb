# frozen_string_literal: true

require 'bootstrap-sass'
require 'everypolitician'
require 'html_truncator'
require 'sinatra'
require 'sinatra/content_for'

require_relative 'lib/checks'
require_relative 'lib/featured_person'
require_relative 'lib/document/finder'
require_relative 'lib/ep/people_by_legislature'
require_relative 'lib/factory/person'
require_relative 'lib/helpers/filepaths_helper'
require_relative 'lib/helpers/layout_helper'
require_relative 'lib/helpers/settings_helper'
require_relative 'lib/mapit/geometry'
require_relative 'lib/mapit/wrapper'
require_relative 'lib/membership_csv/people'
require_relative 'lib/page/basic'
require_relative 'lib/page/homepage'
require_relative 'lib/page/info'
require_relative 'lib/page/place'
require_relative 'lib/page/places'
require_relative 'lib/page/people'
require_relative 'lib/page/person'
require_relative 'lib/page/post'
require_relative 'lib/page/posts'

set :contact_email, 'syeinfo@eienigeria.org'
set :content_dir, File.join(__dir__, 'prose')
set :datasource, ENV.fetch('DATASOURCE', 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json')
set :index, EveryPolitician::Index.new(index_url: settings.datasource)
set :mapit_url, 'https://nigeria.mapit.mysociety.org'
set :mapit_user_agent, ENV.fetch('MAPIT_USER_AGENT', nil)
set :twitter_user, 'NGShineYourEye'

# Create a wrapper for the mappings between the various IDs we have
# to use for areas / places.
mapit_mappings = Mapit::Mappings.new(
  parent_mapping_filenames: [
    'mapit/fed_to_sta_area_ids_mapping.csv',
    'mapit/sen_to_sta_area_ids_mapping.csv',
    'mapit/lga_to_sta_area_ids_mapping.csv'
  ],
  pombola_slugs_to_mapit_ids_filename:
    'mapit/pombola_place_slugs_to_mapit.csv',
  mapit_to_ep_areas_filenames: [
    'mapit/mapit_to_ep_area_ids_mapping_FED.csv',
    'mapit/mapit_to_ep_area_ids_mapping_SEN.csv',
    'mapit/mapit_to_ep_area_ids_mapping_LGA.csv'
  ]
)

# Create a wrapper that caches MapIt and EveryPolitician area data:
mapit = Mapit::Wrapper.new(
  mapit_mappings: mapit_mappings,
  baseurl: '/place/',
  area_types: %w[LGA FED SEN STA],
  data_directory: 'mapit'
)

person_factory = Factory::Person.new(mapit: mapit, baseurl: '/person/', identifier_scheme: 'shineyoureye')

TENURE_TERM = '9th National Assembly of Nigeria'
Legislature = Struct.new(:slug, :name, :latest_term_start_date, :latest_term_end_date, :assembly_term)
# Assemble data on the members of the various legislatures we support:
governors = MembershipCSV::People.new(
  csv_filename: 'morph/nigeria-state-governors.csv',
  legislature: Legislature.new('Governors'),
  person_factory: person_factory
)
representatives = MembershipCSV::People.new(
  csv_filename: 'data/representatives.csv',
  legislature: Legislature.new('Representatives', 'House of Representatives', Date.parse('2019-06-11'), '- current', TENURE_TERM),
  person_factory: person_factory
)
senators = MembershipCSV::People.new(
  csv_filename: 'data/senate.csv',
  legislature: Legislature.new('Senate', 'Senate', Date.parse('2019-06-11'), '- current', TENURE_TERM),
  person_factory: person_factory
)
honorables = MembershipCSV::People.new(
  csv_filename: 'data/honorables.csv',
  legislature: Legislature.new('Honorables', 'House of Assembly', Date.parse('2019-06-11'), '- current'),
  person_factory: person_factory
)

raise_if_missing_slugs(governors, representatives, senators, honorables)

all_people = representatives.find_all + senators.find_all + governors.find_all + honorables.find_all

get '/' do
  posts_finder = Document::Finder.new(pattern: posts_pattern, baseurl: '/blog/')
  events_finder = Document::Finder.new(pattern: events_pattern, baseurl: '/events/')
  @page = Page::Homepage.new(
    posts: posts_finder.find_all,
    events: events_finder.find_all,
    governors: governors,
    senators: senators,
    representatives: representatives,
    honorables: honorables
  )
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
  @redirect_to = '/events/'
  erb :redirect, layout: false
end

get '/events/' do
  finder = Document::Finder.new(pattern: events_pattern, baseurl: '/events/')
  @page = Page::Posts.new(posts: finder.find_all, title: 'Events')
  erb :posts
end

get '/events/:slug' do |slug|
  finder = Document::Finder.new(pattern: event_pattern(slug), baseurl: '/events/')
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

get '/place/:slug/people/' do |slug|
  @redirect_to = "/place/#{slug}/"
  erb :redirect, layout: false
end

get '/place/:slug/places/' do |slug|
  @redirect_to = "/place/#{slug}/"
  erb :redirect, layout: false
end

get '/place/:slug/' do |slug|
  area = mapit.area_from_pombola_slug(slug)
  pass unless area
  people = {
    'Local Government Area' => honorables,
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

get '/position/state-representatives/' do
  @page = Page::Places.new(
    title: 'State Houses of Assembly',
    places: mapit.places_of_type('STA'),
    people_by_legislature: honorables
  )

  @updated_states_legislature = @page.filter_places_with_updated_profile
  @incomplete_states_legislature = @page.filter_places_with_incomplete_profile

  erb :states
end

get '/position/state-representative/' do
  @redirect_to = '/position/state-representatives/'
  erb :redirect, layout: false
end

get '/position/state-representatives/:state/' do |slug|
  @area = mapit.area_from_pombola_slug(slug)
  pass unless @area
  @page = Page::People.new(title: 'State House of Assembly', people_by_legislature: honorables)
  erb :list_of_state_people
end

get '/position/federal-representatives/' do
  @page = Page::People.new(title: 'House of Representatives', people_by_legislature: representatives)
  erb :people
end

get '/position/senator/' do
  @page = Page::People.new(title: 'Senators', people_by_legislature: senators)
  erb :people
end

get '/position/executive-governor/' do
  @page = Page::People.new(title: 'Executive Governors', people_by_legislature: governors)
  erb :people
end

get '/position/representative/' do
  @redirect_to = '/position/federal-representatives/'
  erb :redirect, layout: false
end

get '/person/:slug/contact_details/' do |slug|
  @redirect_to = "/person/#{slug}/"
  erb :redirect, layout: false
end

get '/person/:slug/experience/' do |slug|
  @redirect_to = "/person/#{slug}/"
  erb :redirect, layout: false
end

get '/person/:slug/' do |slug|
  person = honorables.find_single(slug)
  pass unless person
  summary_finder = Document::Finder.new(pattern: summary_pattern(person.id), baseurl: '')
  @page = Page::Person.new(
    person: person,
    position: 'State Representative',
    summary_doc: summary_finder.find_or_empty
  )
  erb :person
end

get '/person/:slug/' do |slug|
  person = representatives.find_single(slug)
  pass unless person
  summary_finder = Document::Finder.new(pattern: summary_pattern(person.id), baseurl: '')
  @page = Page::Person.new(
    person: person,
    position: 'Federal Representative',
    summary_doc: summary_finder.find_or_empty
  )
  erb :person
end

get '/person/:slug/' do |slug|
  person = senators.find_single(slug)
  pass unless person
  summary_finder = Document::Finder.new(pattern: summary_pattern(person.id), baseurl: '')
  @page = Page::Person.new(
    person: person,
    position: 'Senator',
    summary_doc: summary_finder.find_or_empty
  )
  erb :person
end

get '/person/:slug/' do |slug|
  person = governors.find_single(slug)
  pass unless person
  summary_finder = Document::Finder.new(pattern: summary_pattern(person.id), baseurl: '')
  @page = Page::Person.new(
    person: person,
    position: 'Governor',
    summary_doc: summary_finder.find_or_empty
  )
  erb :person
end

get '/search/' do
  @page = Page::Basic.new(title: 'Search')
  erb :search
end

get '/feedback' do
  @redirect_to = '/contact/'
  erb :redirect, layout: false
end

get '/contact/' do
  @page = Page::Basic.new(title: 'Contact')
  erb :contact
end

get '/ids-and-slugs.csv' do
  content_type 'application/csv'
  CSV.generate do |csv|
    csv << %w[id slug]
    all_people.each do |person|
      csv << [person.id, person.slug]
    end
  end
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
  @page = Page::Basic.new(title: '{{ title }}')
  erb :jinja2_contents
end

get '/scraper-start-page.html' do
  @people = all_people
  @places = mapit.places_of_type('FED') + mapit.places_of_type('SEN') + mapit.places_of_type('STA')
  erb :scraper_start_page, layout: false
end
