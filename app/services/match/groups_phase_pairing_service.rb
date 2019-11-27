# frozen_string_literal: true

class Match::GroupsPhasePairingService
  GROUP_PHASE = "groups"

  def self.call(*args)
    new(*args).call
  end

  def initialize(group_name)
    @group_name = group_name
  end

  def call
    teams_from_group.to_a.combination(2).to_a.each do |team1, team2|
      Match.create_single_match(team1, team2, GROUP_PHASE)
    end
  end

  private

  def teams_from_group
    Team.where(group_name: @group_name)
  end
end
