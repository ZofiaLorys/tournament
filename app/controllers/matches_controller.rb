# frozen_string_literal: true

class MatchesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @matches_group_a = Match.where(teams: { group_name: "A" }).includes(:teams)
    @matches_group_b = Match.where(teams: { group_name: "B" }).includes(:teams)
    @matches_playoff_first_round = Match.where(phase: "playoff", rounds_left_playoff: "2")
  end

  def create
    Match::CreateMatchesService.call(matches_params)
    redirect_to action: "index"
  end

  def update
    Match::AssignScoreService.call(matches_params)
    redirect_to action: "index"
  end

  def matches_params
    params.require(:matches).permit(:group_name, :phase, :rounds_left_playoff)
  end
end
