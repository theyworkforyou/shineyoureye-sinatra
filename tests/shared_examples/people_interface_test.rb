# frozen_string_literal: true

class Module
  include Minitest::Spec::DSL
end

module PeopleInterfaceTest
  it 'can find all people' do
    assert_respond_to(people, :find_all)
  end

  it 'can find a single person by id' do
    assert_respond_to(people, :find_single)
  end

  it 'can check if there is no person with an id' do
    assert_respond_to(people, :none?)
  end

  it 'can find all people by mapit area' do
    assert_respond_to(people, :find_all_by_mapit_area)
  end

  it 'can check if there is no person in a mapit area' do
    assert_respond_to(people, :none_by_mapit_area?)
  end

  it 'knows the current term start date' do
    assert_respond_to(people, :current_term_start_date)
  end

  it 'knows the legislature name' do
    assert_respond_to(people, :legislature_name)
  end
end
