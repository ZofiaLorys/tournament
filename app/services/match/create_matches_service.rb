# frozen_string_literal: true

class Match::CreateMatchesService
  GROUP_PHASE = "groups"
  PLAYOFF_PHASE = "playoff"
  AMOUNT_OF_PLAYOFF_ROUNDS = "2"

  def self.call(*args)
    new(*args).call
  end

  def initialize(params)
    @group_name = params["group_name"]
    @phase = params["phase"]
    @rounds_left_playoff = params["rounds_left_playoff"]
  end

  def call
    if @phase == GROUP_PHASE
      Match::GroupsPhasePairingService.call(@group_name)
    elsif @phase == PLAYOFF_PHASE && @rounds_left_playoff == AMOUNT_OF_PLAYOFF_ROUNDS
      Match::PlayoffFirstRoundPairingService.call(@rounds_left_playoff)
    end
  end

  private

  def team_pairing
    if @phase == GROUP_PHASE
      Match::GroupsPhasePairingService.call(@group_name)
    elsif @phase == PLAYOFF_PHASE
      Match::PlayoffFirstRoundPairingService.call(@rounds_left_playoff)
    end
  end
end
