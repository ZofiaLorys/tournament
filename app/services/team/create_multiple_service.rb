# frozen_string_literal: true

require "faker"

class Team::CreateMultipleService
  TEAMS_AMOUNT = 8

  def self.call(*args)
    new(*args).call
  end

  def initialize(group_name)
    @group_name = group_name
  end

  def call
    TEAMS_AMOUNT.to_i.times do
      Team.create!(name: Faker::Team.name, group_name: @group_name)
    end
  end
end
