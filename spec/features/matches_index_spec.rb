# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Matches index page", type: :feature do
  context "when no matches exist" do
    before do
      8.times do
        FactoryBot.create(:team, group_name: "A")
        FactoryBot.create(:team, group_name: "B")
      end
    end

    it "checks page display" do
      visit matches_path
      expect(page).to have_button("Create tournament pairs for a group A")
      expect(page).to have_button("Create tournament pairs for a group B")
      # expect(page).to have_button(count: 2)
      expect(page).not_to have_css "table td"
      expect(page).to have_table
    end

    it "User creates new matches for group A" do
      visit matches_path
      click_button "Create tournament pairs for a group A"

      expect(page).to have_text("You have created matches")
      expect(page).to have_css "table td"
      expect(Match.count).to eq 28
      match = Match.first
      team_name = TeamMatch.where(match: match).first.team.name
      expect(page).to have_text(team_name)
      expect(page).not_to have_button("Create tournament pairs for a group A")
    end
    it "User creates new matches for group B" do
      visit matches_path
      click_button "Create tournament pairs for a group B"

      expect(page).to have_text("You have created matches")
      expect(page).to have_css "table td"
      expect(Match.count).to eq 28
      match = Match.first
      team_name = TeamMatch.where(match: match).first.team.name
      expect(page).to have_text(team_name)
      expect(page).not_to have_button("Create tournament pairs for a group B")
    end
  end

  context "when groups phase matches exists" do
    before do
      28.times do
        team1 = FactoryBot.create(:team, group_name: "A")
        team2 = FactoryBot.create(:team, group_name: "A")
        match = FactoryBot.create(:match, phase: "groups")
        team_match1 = FactoryBot.create(:team_match, team: team1, match: match)
        team_match2 = FactoryBot.create(:team_match, team: team2, match: match)
      end
    end

    it "User generates scores for groups phase matches for group A" do
      visit matches_path
      # expect(page).to have_button(count: 2)
      click_button "Generate scores for a group A"
      expect(Match.count).to eq 28

      match = Match.where(teams: { group_name: "A" }).joins(:team_matches, :teams).first
      team_match = TeamMatch.where(match: match).first
      team = team_match.team
      # td_name = page.find(:xpath, "/html/body/table[1]/tbody/tr[#{match.id + 1}]/td[3]")
      td_name = page.find(:xpath, "/html/body/table[1]/tr[#{match.id + 1}]/td[3]")
      expect(td_name).to have_text(team.name)
    end
  end
end
