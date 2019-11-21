# frozen_string_literal: true

class TeamMatch < ApplicationRecord
  belongs_to :team
  belongs_to :match
end
