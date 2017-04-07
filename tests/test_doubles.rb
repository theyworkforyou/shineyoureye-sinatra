# frozen_string_literal: true

FakeSummary = Struct.new(:slug, :body)

FakePlace = Struct.new(:id, :name, :url)
FakeMapit = Struct.new(:mapit_id) do
  def area_from_ep_id(_id)
    FakePlace.new(mapit_id, 'Mapit Area Name', '/place/pombola-slug/')
  end

  def area_from_mapit_name(_name)
    FakePlace.new(mapit_id)
  end
end

FakePerson = Struct.new(:id, :name, :slug, :phone, :mapit)
