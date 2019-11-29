# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchesController, type: :request do
  context "when creating matches in groups phase" do
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

  context "when generating scores in groups phase" do
    let!(:match) { FactoryBot.create(:match, :with_teams) }
    let(:params) do
      { matches: { group_name: "C", phase: "groups" } }
    end

    it "updates score" do
      post "/matches/update", params: params
      expect(TeamMatch.where(match: match)).not_to be_nil
      expect(response.status).to eq(302)
    end
  end
end
