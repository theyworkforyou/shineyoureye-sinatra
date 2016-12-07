require 'sinatra'
require 'everypolitician'

set :datasource, ENV.fetch('DATASOURCE', 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json')
set :index, EveryPolitician::Index.new(index_url: settings.datasource)
set :country, settings.index.country('Nigeria')

get '/' do
  erb :homepage
end

get '/places/' do
  @country = settings.country
  erb :places
end
