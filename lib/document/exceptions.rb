# frozen_string_literal: true
module Document
  class NoFilesFoundError < StandardError
    def initialize(msg = 'No files found')
      super
    end
  end
end
