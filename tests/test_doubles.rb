FakePlace = Struct.new(:id, :name, :url)
FakeMapit = Struct.new(:mapit_id) do
  def area_from_ep_id(id)
    FakePlace.new(mapit_id, 'Mapit Area Name', '/place/pombola-slug/')
  end

  def area_from_mapit_name(name)
    FakePlace.new(mapit_id)
  end
end
