# frozen_string_literal: true

class TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @teams_group_a = Team.where(group_name: "A")
    @teams_group_b = Team.where(group_name: "B")
  end

  def create
    Team::CreateMultipleService.call(teams_params[:group_name])
    flash[:success] = "You have created 8 teams from group #{teams_params[:group_name]}"
    redirect_to action: "index"
  end

  def teams_params
    params.require(:teams).permit(:group_name)
  end
end
