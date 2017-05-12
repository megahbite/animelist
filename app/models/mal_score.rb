# frozen_string_literal: true

class MalScore < ApplicationRecord
  belongs_to :scoreable, polymorphic: true
end
