# frozen_string_literal: true
module Page
  class Post
    def initialize(post:)
      @post = post
    end

    def title
      post.title
    end

    def date
      post.date.strftime("%B %-d, %Y")
    end

    def body
      post.body
    end

    private

    attr_reader :post
  end
end
