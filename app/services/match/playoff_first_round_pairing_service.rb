# frozen_string_literal: true

class Match::PlayoffFirstRoundPairingService
  GROUP_PHASE = "playoff"
  FIRST_GROUP = "A"
  SECOND_GROUP = "B"

  def self.call(*args)
    new(*args).call
  end

  def initialize(rounds_left_playoff)
    @rounds_left_playoff = rounds_left_playoff
  end

  def call
    playoff_pairs.each do |team1_id, team2_id|
      team1 = Team.find(team1_id)
      team2 = Team.find(team2_id)
      Match.create_single_match(team1, team2, GROUP_PHASE)
    end
  end

  private

  def playoff_pairs
    best_scores_first_group = best_scores_in_a_group(FIRST_GROUP, amount_of_matches)
    best_scores_second_group = best_scores_in_a_group(SECOND_GROUP, amount_of_matches)
    best_scores_second_group.reverse!
    best_scores_first_group.zip(best_scores_second_group)
  end

  def best_scores_in_a_group(group_name, _amount)
    TeamMatch.where(teams: { group_name: group_name }).group(:team_id).joins(:team).order(sum_score: :desc)
    .limit(4).sum(:score).keys
  end

  def amount_of_matches
    @rounds_left_playoff.to_i**2
  end
end
