# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchesController, type: :request do
  context "when POST #create" do
    let(:params) do
      { matches: { group_name: "C", phase: "groups" } }
    end

    8.times do
      before do
        FactoryBot.create(:team)
      end
    end

    it "creates 28 matches" do
      expect { post "/matches", params: params }
        .to change(Match, :count).by(28)
      expect(response.status).to eq(302)
    end
  end

  context "when POST #update" do
    before { FactoryBot.create(:team_match, match: match, team: team2) }

    let!(:team_match1) { FactoryBot.create(:team_match, match: match, team: team1) }
    let!(:match) { FactoryBot.create(:match) }
    let!(:team2) { FactoryBot.create(:team) }
    let!(:team1) { FactoryBot.create(:team) }
    let(:params) do
      { matches: { group_name: "C" } }
    end

    it "updates score" do
      post "/matches/update", params: params
      team_match1.reload
      expect(team_match1.score).not_to be_nil
      expect(response.status).to eq(302)
    end
  end
end
