# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/breadcrumbs/breadcrumb'

describe 'Breadcrumbs::Breadcrumb' do
  let(:breadcrumb) {Breadcrumbs::Breadcrumb.new('/foo/', 'Foo')}

  it 'has a route' do
    breadcrumb.route.must_equal('/foo/')
  end

  it 'has a display text' do
    breadcrumb.display_text.must_equal('Foo')
  end
end
