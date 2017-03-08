# frozen_string_literal: true

require 'sinatra'
require 'bootstrap-sass'
require 'sass/plugin/rack'
require './app'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

run Sinatra::Application
