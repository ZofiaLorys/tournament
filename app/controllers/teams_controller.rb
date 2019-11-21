# frozen_string_literal: true

require "faker"

class TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @teams_group_A = Team.where(group_name: "A")
    @teams_group_B = Team.where(group_name: "B")
  end

  def show
    puts params
  end

  def create_multiple
    teams_amount = teams_params[:teams_amount]
    group_name = teams_params[:group_name]
    teams_amount.to_i.times do
      @team = Team.create!(name: Faker::Team.name, group_name: group_name)
    end
    redirect_to action: "index"
  end

  def update; end

  def teams_params
    params.require(:teams).permit(:teams_amount, :group_name)
  end
end
