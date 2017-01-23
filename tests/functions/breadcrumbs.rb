# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/functions/breadcrumbs'

describe 'make_breadcrumbs' do
  it 'should handle the root path, with a default name' do
    assert_equal(
      [
        ['/', 'Home']
      ],
      make_breadcrumbs('/', {})
    )
  end

  it 'should handle the root path, with a custom name' do
    breadcrumbs_prefix_map = { '/' => 'Awesome' }
    assert_equal(
      [
        ['/', 'Awesome']
      ],
      make_breadcrumbs('/', breadcrumbs_prefix_map)
    )
  end

  it 'should treat the empty path as the root path' do
    assert_equal(
      [
        ['/', 'Home']
      ],
      make_breadcrumbs('', {})
    )
  end

  it 'should handle handle multiple path parts' do
    assert_equal(
      [
        ['/', 'Home'],
        ['/foo', 'foo'],
        ['/foo/bar', 'bar']
      ],
      make_breadcrumbs('/foo/bar', {})
    )
  end

  it 'should handle handle multiple path parts with custom names' do
    breadcrumbs_prefix_map = {
      '/people' => 'Politicians',
      '/people/mps' => 'MPs',
      '/places' => 'Places'
    }
    assert_equal(
      [
        ['/', 'Home'],
        ['/people', 'Politicians'],
        ['/people/mps', 'MPs']
      ],
      make_breadcrumbs('/people/mps', breadcrumbs_prefix_map)
    )
  end

  it 'should ignore an item where the prefix maps to nil' do
    breadcrumbs_prefix_map = {
      '/info' => nil,
    }
    assert_equal(
      [
        ['/', 'Home'],
        ['/info/places-overview', 'places-overview']
      ],
      make_breadcrumbs('/info/places-overview/', breadcrumbs_prefix_map)
    )
  end
end
