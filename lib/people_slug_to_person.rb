# frozen_string_literal: true
module PeopleSlugToPerson
  private

  def slug_to_person
    @slug_to_person ||= find_all.each_with_object({}) { |person, memo| ensure_unique_slug(person, memo) }
  end

  def ensure_unique_slug(person, memo)
    raise_if_no_slug(person)
    raise_if_repeated_slug(person, memo)
    memo[person.slug] = person
  end

  def raise_if_no_slug(person)
    raise "No slug for #{person.name}" unless person.slug
  end

  def raise_if_repeated_slug(person, memo)
    raise "Slug #{person.slug} repeated for #{memo[person.slug].name} and #{person.name}" if memo[person.slug]
  end
end
