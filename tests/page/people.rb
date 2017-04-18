# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/people_by_legislature'
require_relative '../../lib/page/people'

describe 'Page::People' do
  let(:people) do
    EP::PeopleByLegislature.new(
      legislature: nigeria_at_known_revision.legislature('Representatives'),
      person_factory: FakePersonFactory.new(FakeMapit.new(1))
    )
  end
  let(:page) do
    Page::People.new(
      title: 'Federal Representative',
      people_by_legislature: people
    )
  end

  it 'has a title' do
    page.title.must_equal('Federal Representative')
  end

  it 'has a list of representatives' do
    page.people.first.name.must_equal('ABDUKADIR RAHIS')
  end
end
