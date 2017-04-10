# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/people_by_legislature'
require_relative '../../lib/membership_csv/people'
require_relative '../../lib/page/person'
require_relative '../shared_examples/person_interface_test'

describe 'Page::Person' do
  let(:page) do
    Page::Person.new(
      person: FakePerson.new(nil, 'ABDUKADIR RAHIS'),
      position: 'Position',
      summary_doc: FakeSummary.new('irrelevant', '<p>foo</p>')
    )
  end

  it 'knows the position' do
    page.position.must_equal('Position')
  end

  it 'has a page title' do
    page.title.must_equal('ABDUKADIR RAHIS')
  end

  it 'has a social media share name' do
    page.share_name.must_equal('ABDUKADIR RAHIS')
  end

  it 'has a summary' do
    page.summary.must_equal('<p>foo</p>')
  end

  describe 'when page is an EP person' do
    include PersonInterfaceTest
    let(:person) { page.person }
  end

  describe 'when page is a Morph person' do
    include PersonInterfaceTest
    let(:contents) do
      'identifier__shineyoureye
foo'
    end
    let(:people) do
      MembershipCSV::People.new(
        csv_filename: new_tempfile(contents),
        mapit: 'irrelevant',
        baseurl: 'irrelevant',
        identifier_scheme: 'shineyoureye'
      )
    end
    let(:page) do
      Page::Person.new(
        person: people.find_single('foo'),
        position: 'irrelevant',
        summary_doc: 'irrelevant'
      )
    end
    let(:person) { page.person }
  end
end
