# frozen_string_literal: true

class Match::AssignScoreService
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
      generate_scores(matches_in_groups_phase)
    elsif in_playoff_phase
      generate_scores(matches_in_playoff_phase)
    end
  end

  private

  def matches_in_groups_phase
    Match.where(phase: "groups", teams: { group_name: @group_name }).includes(:teams)
  end

  def matches_in_playoff_phase
    Match.where(phase: "playoff", rounds_left_playoff: @rounds_left_playoff)
  end

  def generate_scores(matches)
    matches.each do |match|
      score = random_score
      TeamMatch.where(match: match).first.update(score: score[0])
      TeamMatch.where(match: match).last.update(score: score[1])
    end
  end

  def random_score
    if @phase == GROUP_PHASE
      [[3, 0], [0, 3], [1, 1]].sample
    else
      [[3, 0], [0, 3]].sample
    end
  end

  def in_groups_phase
    @phase == GROUP_PHASE
  end

  def in_playoff_phase
    @phase == PLAYOFF_PHASE
  end
end
