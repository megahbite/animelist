# frozen_string_literal: true

class UserScore < ApplicationRecord
  belongs_to :user
  belongs_to :anime
end
