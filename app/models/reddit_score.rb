# frozen_string_literal: true

class RedditScore < ApplicationRecord
  belongs_to :scoreable, polymorphic: true
end
