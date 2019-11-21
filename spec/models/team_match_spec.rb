RSpec.describe TeamMatch, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:match) }


end

