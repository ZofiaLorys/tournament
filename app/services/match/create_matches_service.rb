# frozen_string_literal: true

class Match::CreateMatchesService
  GROUP_PHASE = "groups"
  PLAYOFF_PHASE = "playoff"
  AMOUNT_OF_PLAYOFF_ROUNDS = "3"

  def self.call(*args)
    new(*args).call
  end

  def initialize(params)
    @group_name = params["group_name"]
    @phase = params["phase"]
    @rounds_left_playoff = params["rounds_left_playoff"]
  end

  def call
    if in_groups_phase
      Match::GroupsPhasePairingService.call(@group_name)
    elsif in_first_playoff_round
      Match::PlayoffFirstRoundPairingService.call(@rounds_left_playoff)
    elsif in_playoff_round
      Match::PlayoffPairingService.call(@rounds_left_playoff)
    end
  end

  private

  def in_groups_phase
    @phase == GROUP_PHASE
  end

  def in_first_playoff_round
    @phase == PLAYOFF_PHASE && @rounds_left_playoff == AMOUNT_OF_PLAYOFF_ROUNDS
  end

  def in_playoff_round
    @phase == PLAYOFF_PHASE && @rounds_left_playoff != AMOUNT_OF_PLAYOFF_ROUNDS
  end
end
