# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/breadcrumbs/builder'
require_relative '../../lib/breadcrumbs/route_to_display_text_wrapper'

describe 'Breadcrumbs::Builder' do
  let(:builder) { Breadcrumbs::Builder.new(
    current_url: 'http://example.com/foo/bar/a-slug/',
    routes_wrapper: Breadcrumbs::RouteToDisplayTextWrapper.new(
      routes: {
        '/' => 'Home',
        '/foo/bar/' => 'Bar',
        '/another_path/' => 'Display Text'
      }
    )
  ) }

  it 'detects all breadcrumbs' do
    builder.breadcrumbs.count.must_equal(2)
  end

  it 'returns the home breadcrumb' do
    builder.breadcrumbs.first.route.must_equal('/')
    builder.breadcrumbs.first.display_text.must_equal('Home')
  end

  it 'does not have the current page breadcrumb' do
    builder.breadcrumbs.last.route.must_equal('/foo/bar/')
    builder.breadcrumbs.last.display_text.must_equal('Bar')
  end

  it 'does not have breadcrumbs if it is the home page' do
    builder = Breadcrumbs::Builder.new(
      current_url: 'http://example.com/',
      routes_wrapper: Breadcrumbs::RouteToDisplayTextWrapper.new(
        routes: { '/' => 'Home' }
    ))
    builder.breadcrumbs.must_be_empty
  end
end
