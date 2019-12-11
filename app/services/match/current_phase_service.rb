# frozen_string_literal: true

class Match::CurrentPhaseService
  def self.call(*args)
    new(*args).call
  end

  def initialize
    @teams_exists = Team.where(group_name: "A").any? && Team.where(group_name: "B").any?
    @matches_group_a = Match.where(teams: { group_name: "A" }).includes(:teams, :team_matches)
    @matches_group_b = Match.where(teams: { group_name: "B" }).includes(:teams, :team_matches)
    @matches_playoff_first_round = Match.where(phase: "playoff", rounds_left_playoff: "3")
    @matches_playoff_semifinal = Match.where(phase: "playoff", rounds_left_playoff: "2")
    @matches_playoff_final = Match.where(phase: "playoff", rounds_left_playoff: "1")
  end

  def call
    if matches_group_a_ready?
      "matches_for_group_A"
    elsif matches_group_b_ready?
      "matches_for_group_B"
    elsif scores_group_a_ready?
      "scores_generating_for_group_A"
    elsif scores_group_b_ready?
      "scores_generating_for_group_B"
    elsif playoff_matches_ready?
      "matches_for_playoff"
    elsif playoff_scores_ready?
      "scores_for_playoff"
    elsif semifinal_matches_ready?
      "matches_for_playoff_semifinal"
    elsif semifinal_scores_ready?
      "scores_for_playoff_semifinal"
    elsif final_matches_ready?
      "pairs_for_playoff_final"
    elsif final_scores_ready?
      "scores_for_playoff_final"
    elsif results_ready?
      "tournament_complete_results"
    end
  end

  private

  def matches_group_a_ready?
    @teams_exists && @matches_group_a.empty?
  end

  def matches_group_b_ready?
    @teams_exists && @matches_group_b.empty?
  end

  def scores_group_a_ready?
    @matches_group_a.present? && @matches_group_a.first.team_matches.first.score.nil?
  end

  def scores_group_b_ready?
    @matches_group_b.present? && @matches_group_b.first.team_matches.first.score.nil?
  end

  def playoff_matches_ready?
    @matches_group_b.present? && @matches_group_b.first.team_matches.first.score.present? &&
      @matches_group_a.present? && @matches_group_a.first.team_matches.first.score.present? &&
      @matches_playoff_first_round.empty?
  end

  def playoff_scores_ready?
    @matches_playoff_first_round.present? && @matches_playoff_first_round.first.team_matches.first.score.nil?
  end

  def semifinal_matches_ready?
    @matches_playoff_first_round.present? &&
      @matches_playoff_first_round.first.team_matches.first.score.present? && @matches_playoff_semifinal.empty?
  end

  def semifinal_scores_ready?
    @matches_playoff_semifinal.present? && @matches_playoff_semifinal.first.team_matches.first.score.nil?
  end

  def final_matches_ready?
    @matches_playoff_semifinal.present? && @matches_playoff_semifinal.first.team_matches.first.score.present? &&
      @matches_playoff_final.empty?
  end

  def final_scores_ready?
    @matches_playoff_final.present? && @matches_playoff_final.first.team_matches.first.score.nil?
  end

  def results_ready?
    @matches_playoff_final.present? && @matches_playoff_final.first.team_matches.first.score.present?
  end
end
