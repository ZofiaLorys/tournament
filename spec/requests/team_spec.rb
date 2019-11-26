# frozen_string_literal: true

RSpec.describe TeamsController, type: :request do
  describe "POST #create" do
    let(:params) do
      { teams: { group_name: "A" } }
    end

    it "creates 8 teams" do
      expect { post "/teams", params: params }
        .to change(Team, :count).by(8)
      expect(response.status).to eq(302)
    end
  end
end
