# frozen_string_literal: true

module Document
  class EmptyDocument
    def featured?
      false
    end

    def body
      ''
    end
  end
end
