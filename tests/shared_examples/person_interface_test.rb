# frozen_string_literal: true

class Module
  include Minitest::Spec::DSL
end

module PersonInterfaceTest
  it 'has a url to a medium-sized image' do
    assert_respond_to(person, :medium_image_url)
  end

  it 'has a name' do
    assert_respond_to(person, :name)
  end

  it 'has an area' do
    assert_respond_to(person, :area)
  end

  it 'has a party name' do
    assert_respond_to(person, :party_name)
  end

  it 'has a birth date' do
    assert_respond_to(person, :birth_date)
  end

  it 'has a phone' do
    assert_respond_to(person, :phone)
  end

  it 'has a Twitter' do
    assert_respond_to(person, :twitter)
  end

  it 'has a Twitter url' do
    assert_respond_to(person, :twitter_url)
  end

  it 'has a Twitter display' do
    assert_respond_to(person, :twitter_display)
  end

  it 'has a Facebook' do
    assert_respond_to(person, :facebook)
  end

  it 'has a Facebook url' do
    assert_respond_to(person, :facebook_url)
  end

  it 'has a Facebook display' do
    assert_respond_to(person, :facebook_display)
  end

  it 'has an email' do
    assert_respond_to(person, :email)
  end

  it 'has an email url' do
    assert_respond_to(person, :email_url)
  end

  it 'has a wikipedia url' do
    assert_respond_to(person, :wikipedia_url)
  end

  it 'has an id' do
    assert_respond_to(person, :id)
  end

  it 'has a slug' do
    assert_respond_to(person, :slug)
  end
end
