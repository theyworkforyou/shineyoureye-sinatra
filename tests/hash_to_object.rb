# frozen_string_literal: true
require 'test_helper'
require_relative '../lib/hash_to_object'

describe 'HashToObject' do
  it 'works with string keys' do
    hash = extend('foo': 'bar')
    hash.foo.must_equal('bar')
  end

  it 'works with symbol keys' do
    hash = extend(foo: [1, 2])
    hash.foo.must_equal([1, 2])
  end

  it 'nils if key does not exist' do
    hash = extend(foo: 42)
    assert_nil(hash.bar)
  end

  it 'converts nested levels' do
    hash = extend(the: { answer: 42 })
    hash.the.answer.must_equal(42)
  end

  it 'responds to keys as methods' do
    hash = extend(foo: { bar: 'qux' })
    hash.respond_to?(:foo).must_equal(true)
    hash.foo.respond_to?(:bar).must_equal(true)
    hash.respond_to?(:i_dont_exist).must_equal(false)
  end

  it 'keys are indeed methods' do
    hash = extend(foo: { bar: 'qux' })
    hash.method(:foo).is_a?(Method).must_equal(true)
    hash.foo.method(:bar).is_a?(Method).must_equal(true)
  end

  def extend(hash)
    hash.extend(HashToObject).to_object
  end
end
