# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/people_by_legislature'
require_relative '../../lib/page/person'

describe 'Page::Person' do
  let(:people) { EP::PeopleByLegislature.new(
    legislature: nigeria_at_known_revision.legislature('Representatives'),
    mapit: FakeMapit.new(1),
    baseurl: '/baseurl/'
  ) }
  let(:page) { Page::Person.new(
    person: people.find_single('b2a7f72a-9ecf-4263-83f1-cb0f8783053c'),
    position: 'Position'
  ) }

  it 'knows the position' do
    page.position.must_equal('Position')
  end

  it 'has a page title' do
    page.title.must_equal('ABDUKADIR RAHIS')
  end

  it 'has a name' do
    page.person.name.must_equal('ABDUKADIR RAHIS')
  end

  it 'has a social media share name' do
    page.share_name.must_equal('ABDUKADIR RAHIS')
  end

  it 'has an image' do
    page.person.image.must_include('/images/mps/546.jpg')
  end

  it 'has a thumbnail image' do
    page.person.thumbnail_image_url.must_include('/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/100x100.jpeg')
  end

  it 'knows the area url' do
    page.person.area.url.must_equal('/place/pombola-slug/')
  end

  it 'knows the area name' do
    page.person.area.name.must_equal('Mapit Area Name')
  end

  it 'knows the party url' do
    page.person.party_url.must_equal('/organisation/apc/')
  end

  it 'knows the party name' do
    page.person.party_name.must_equal('All Progressives Congress')
  end

  it 'has a summary' do
    page.summary.must_equal('')
  end

  it 'knows the executive positions' do
    page.executive_positions.must_equal([])
  end

  it 'knows the job history' do
    page.job_history.must_equal([])
  end

  it 'knows the education' do
    page.education.must_equal([])
  end
end
