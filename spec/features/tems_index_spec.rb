# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Teams index page", type: :feature do
  context "when there are no teams created" do
    it "Visits teams page for the first time" do
      visit teams_path
      expect(page).not_to have_css "table td"
      expect(page).to have_table
      expect(page).to have_button(minimum: 2)
    end
  end

  context "when creating teams" do
    it "User creates new teams for group A" do
      visit teams_path
      click_button "Create 8 teams in a group A"
      expect(page).to have_text("You have created 8 teams from group A")
      expect(page).to have_css "table td"
      expect(Team.count).to eq 8
      team = Team.first
      expect(page).to have_text(team.name)
      expect(page).not_to have_button("Create 8 teams in a group A")
    end

    it "User creates new teams for group B" do
      visit teams_path
      click_button "Create 8 teams in a group B"
      expect(page).to have_text("You have created 8 teams from group B")
      expect(page).to have_css "table td"
      expect(Team.count).to eq 8
      team = Team.first
      expect(page).to have_text(team.name)
      expect(page).not_to have_button("Create 8 teams in a group B")
    end
  end

  context "when teams of both groups are created" do
    before do
      8.times do
        FactoryBot.create(:team, group_name: "A")
        FactoryBot.create(:team, group_name: "B")
      end
    end

    it "checks the page display" do
      visit teams_path
      expect(page).to have_css "table td"
      expect(page).not_to have_button
      expect(Team.count).to eq 16
      team = Team.first
      expect(page).to have_text(team.name)
    end
  end
end
