# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/breadcrumbs/route_to_display_text_wrapper'

describe 'Breadcrumbs::RouteToDisplayTextWrapper' do
  let(:wrapper) { Breadcrumbs::RouteToDisplayTextWrapper.new(
    routes: {'/' => 'Home', '/foo/bar/' => 'Display Text'}
  ) }

  it 'maps all routes with their display texts' do
    wrapper.breadcrumbify.count.must_equal(2)
  end

  it 'returns the home pair' do
    wrapper.breadcrumbify.first.route.must_equal('/')
    wrapper.breadcrumbify.first.display_text.must_equal('Home')
  end

  it 'returns the other routes' do
    wrapper.breadcrumbify.last.route.must_equal('/foo/bar/')
    wrapper.breadcrumbify.last.display_text.must_equal('Display Text')
  end
end
