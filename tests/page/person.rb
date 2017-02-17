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
    # Patch the summary_markdown_filename to point to a file with
    # known Markdown content.
    def page.summary_markdown_filename
      File.join(
        File.dirname(__FILE__), '..', 'fixtures', 'example-summary.md'
      )
    end
    page.summary.must_equal(
      "<p>Some example summary text</p>

<h3>Positions</h3>

<ul>
<li>First item in the list</li>
<li>Second item in the list</li>
</ul>

"
    )
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

  it 'can find the filename for the Markdown summary text' do
    expected_relative = File.join(
      File.dirname(__FILE__), '..', '..', 'prose', 'summaries',
      'b2a7f72a-9ecf-4263-83f1-cb0f8783053c.md'
    )
    expected_absolute = Pathname.new(expected_relative).cleanpath
    actual_relative = page.send(:summary_markdown_filename)
    actual_absolute = Pathname.new(actual_relative).cleanpath
    actual_absolute.must_equal(expected_absolute)
  end

end
