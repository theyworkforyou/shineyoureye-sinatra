# frozen_string_literal: true
require 'json'
require 'ostruct'

module HashToObject
  def to_object
    JSON.parse(to_json, object_class: OpenStruct)
  end
end
