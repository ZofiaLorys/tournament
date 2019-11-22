# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :team_matches
  has_many :matches, through: :team_matches
end
