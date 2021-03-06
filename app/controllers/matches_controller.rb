# frozen_string_literal: true

class MatchesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @teams_exists = Team.where(group_name: "A").any? && Team.where(group_name: "B").any?
    @matches_group_a = Match.where(teams: { group_name: "A" }, phase: "groups").includes(:teams)
    @matches_group_b = Match.where(teams: { group_name: "B" }, phase: "groups").includes(:teams)
    @matches_playoff_first_round = Match.where(phase: "playoff", rounds_left_playoff: "3")
    @matches_playoff_semifinal = Match.where(phase: "playoff", rounds_left_playoff: "2")
    @matches_playoff_final = Match.where(phase: "playoff", rounds_left_playoff: "1")
    @current_phase = Match::CurrentPhaseService.call
  end

  def create
    if Match::CreateMatchesService.call(matches_params).present?
      flash[:success] = "You have created matches "
    else
      flash[:error] = "something went wrong"
    end
    redirect_to action: "index"
  end

  def update
    if Match::AssignScoreService.call(matches_params).present?
      flash[:success] = "You have updated scores"
      redirect_to action: "index"
    else
      flash[:error] = "something went wrong"
    end
  end

  private

  def matches_params
    params.require(:matches).permit(:group_name, :phase, :rounds_left_playoff)
  end
end
