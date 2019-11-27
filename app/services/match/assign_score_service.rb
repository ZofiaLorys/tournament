# frozen_string_literal: true

class Match::AssignScoreService
  def self.call(*args)
    new(*args).call
  end

  def initialize(params)
    @group_name = params["group_name"]
  end

  def call
    matches.each do |match|
      score = random_score

      TeamMatch.where(match: match).first.update(score: score[0])
      TeamMatch.where(match: match).last.update(score: score[1])
    end
  end

  private

  def random_score
    [[3, 0], [0, 3], [1, 1]].sample
  end

  def matches
    Match.where(teams: { group_name: @group_name }).includes(:teams)
  end
end
