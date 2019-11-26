# frozen_string_literal: true

class Match::CreateMatchesService
  GROUP_PHASE = "groups"

  def self.call(*args)
    new(*args).call
  end

  def initialize(group_name)
    @group_name = group_name
  end

  def call
    team_pairing(teams_from_group)
  end

  private

  def team_pairing(teams_from_group)
    teams_from_group.to_a.combination(2).to_a.each do |team1, team2|
      match = Match.create(phase: GROUP_PHASE)
      TeamMatch.create(match: match, team: team1)
      TeamMatch.create(match: match, team: team2)
    end
  end

  def teams_from_group
    Team.where(group_name: @group_name)
  end
end
