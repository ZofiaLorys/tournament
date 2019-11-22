# frozen_string_literal: true

RSpec.describe Match, type: :model do
  it { is_expected.to have_many(:team_matches) }
  it { is_expected.to have_many(:teams).through(:team_matches) }
end
