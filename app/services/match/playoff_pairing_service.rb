# frozen_string_literal: true

class Match::PlayoffPairingService
  PLAYOFF_PHASE = "playoff"

  def self.call(*args)
    new(*args).call
  end

  def initialize(rounds_left_playoff)
    @rounds_left_playoff = rounds_left_playoff
  end

  def call
    winners.to_a.each_slice(2).to_a.each do |team1, team2|
      Match.create_single_match(team1, team2, PLAYOFF_PHASE, @rounds_left_playoff)
    end
  end

  private

  def winners
    previous_rounds_left_playoff = @rounds_left_playoff.to_i + 1
    Team.where(
      matches: { phase: "playoff", rounds_left_playoff: previous_rounds_left_playoff }, team_matches: { score: 3 }
    )
        .includes(:matches, :team_matches)
  end

  def amount_of_matches
    2**@rounds_left_playoff.to_i
  end
end
