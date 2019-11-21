class Match < ApplicationRecord
  has_many :team_matches
  has_many :teams, through: :team_matches
end
