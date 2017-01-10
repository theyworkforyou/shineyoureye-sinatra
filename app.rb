require 'everypolitician'
require 'sinatra'

require_relative 'lib/document/markdown_with_frontmatter'
require_relative 'lib/helpers/constants_helper'

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
  @posts = Dir.glob("#{posts_dir}/*.md").map do |filename|
    Document::MarkdownWithFrontmatter.new(filename: filename, baseurl: '/blog/')
  end.sort_by { |d| d.date }.reverse
  erb :posts
end

get '/blog/:slug' do |slug|
  date_glob = '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
  posts = Dir.glob("#{posts_dir}/#{date_glob}-#{slug}.md")
  raise Sinatra::NotFound if posts.length == 0
  raise "Multiple posts matched '#{slug}': #{posts}" if posts.length > 1
  @post = Document::MarkdownWithFrontmatter.new(filename: posts[0], baseurl: '/blog/')
  erb :post
end
