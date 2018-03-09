# frozen_string_literal: true

require 'everypolitician'

module EveryPolitician
  module LegislativePeriodExtension
    def people
      @people ||= memberships.map(&:person).uniq(&:id)
    end

    def memberships
      @mems ||= legislature.popolo.memberships.select do |mem|
        mem.legislative_period_id == id
      end
    end
  end
end

EveryPolitician::LegislativePeriod.include EveryPolitician::LegislativePeriodExtension
