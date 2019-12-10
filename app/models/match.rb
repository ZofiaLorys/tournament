# frozen_string_literal: true

class Match < ApplicationRecord
  has_many :team_matches
  has_many :teams, through: :team_matches

  def self.create_single_match(team1, team2, phase, rounds_left_playoff = nil)
    match = Match.create(phase: phase, rounds_left_playoff: rounds_left_playoff)
    TeamMatch.create(match: match, team: team1)
    TeamMatch.create(match: match, team: team2)
  end
end
