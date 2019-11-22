# frozen_string_literal: true

RSpec.describe Team, type: :model do
  it { is_expected.to have_many(:team_matches) }
  it { is_expected.to have_many(:matches).through(:team_matches) }
end
