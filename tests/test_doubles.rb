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

FakePerson = Struct.new(:id, :name, :slug, :phone, :mapit) do
  def area
    FakePlace.new(mapit.mapit_id)
  end
end

FakePersonFactory = Struct.new(:mapit) do
  def build_csv_person(row, _legislature)
    FakePerson.new(row['id'], row['name'], row['identifier__shineyoureye'], row['phone'], mapit)
  end

  def build_ep_person(person, _term)
    FakePerson.new(person.id, person.name, person.identifier('shineyoureye'), '', mapit)
  end
end
