FakePlace = Struct.new(:id, :name, :url)
class FakeMapit
  def area_from_ep_id(id)
    FakePlace.new('Mapit Area id', 'Mapit Area Name', '/place/pombola-slug/')
  end
end
