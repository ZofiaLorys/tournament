# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchesController, type: :request do
  describe "POST #create" do
    let(:params) do
      { matches: { group_name: "C" } }
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
end
