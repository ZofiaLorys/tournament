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
      expect(page).not_to have_css "table td"
      expect(page).to have_table
    end

    it "User creates new matches for group A" do
      visit matches_path
      expect(page).to have_button.once
      click_button "Create tournament pairs for a group A"

      expect(page).to have_text("You have created matches")
      expect(page).to have_css "table td"
      expect(Match.count).to eq 28
      match = Match.first
      team_name = TeamMatch.where(match: match).first.team.name
      expect(page).to have_text(team_name)
      expect(page).not_to have_button("Create tournament pairs for a group A")
    end
  end

  context "when matches in group A already exists" do
    before do
      8.times do
        FactoryBot.create(:team, group_name: "A")
        FactoryBot.create(:team, group_name: "B")
      end
      Team.where(group_name: "A").to_a.combination(2).to_a.each do |team1, team2|
        Match.create_single_match(team1, team2, "groups")
      end
    end

    it "User creates new matches for group B" do
      visit matches_path
      expect(page).to have_button.once
     click_button "Create tournament pairs for a group B"

      expect(page).to have_text("You have created matches")
      expect(page).to have_css "table td"
      expect(Match.where(teams: { group_name: "B" }).includes(:teams).count).to eq 28
      match = Match.first
      team_name = TeamMatch.where(match: match).first.team.name
      expect(page).to have_text(team_name)
      expect(page).not_to have_button("Create tournament pairs for a group B")
    end
  end

  context "when groups phase matches exists" do
    before do
      8.times do
        FactoryBot.create(:team, group_name: "A")
        FactoryBot.create(:team, group_name: "B")
      end
      Team.where(group_name: "A").to_a.combination(2).to_a.each do |team1, team2|
        Match.create_single_match(team1, team2, "groups")
      end
      Team.where(group_name: "B").to_a.combination(2).to_a.each do |team1, team2|
        Match.create_single_match(team1, team2, "groups")
      end
    end

    it "User generates scores for groups phase matches for group A" do
      visit matches_path
      expect(Match.where(teams: { group_name: "A" }).includes(:teams).count).to eq 28
      expect(page).to have_button.once
      click_button "Generate scores for a group A"
      match = Match.where(teams: { group_name: "A" }).joins(:team_matches, :teams).first
      team_match = TeamMatch.where(match: match).first
      team = team_match.team
      td_team_name = page.find(:xpath, "/html/body/table[1]/tbody/tr[td[1]/text()=#{match.id}]/td[3]")
      expect(td_team_name).to have_text(team.name)
      expect(page).not_to have_button("Generate scores for a group A")
    end
  end

  context "when scores from group A already exists" do
    before do
      8.times do
        FactoryBot.create(:team, group_name: "A")
        FactoryBot.create(:team, group_name: "B")
      end
      Team.where(group_name: "A").to_a.combination(2).to_a.each do |team1, team2|
        Match.create_single_match(team1, team2, "groups")
      end
      Team.where(group_name: "B").to_a.combination(2).to_a.each do |team1, team2|
        Match.create_single_match(team1, team2, "groups")
      end
      Match.where(teams: { group_name: "A" }).includes(:teams).each do |match|
        score = [[3, 0], [0, 3], [1, 1]].sample
        TeamMatch.where(match: match).first.update(score: score[0])
        TeamMatch.where(match: match).last.update(score: score[1])
      end
    end
    it "User generates scores for groups phase matches for group B" do
      visit matches_path
      expect(Match.where(teams: { group_name: "B" }).includes(:teams).count).to eq 28
      expect(page).to have_button.once
      click_button "Generate scores for a group B"
      match = Match.where(teams: { group_name: "B" }).joins(:team_matches, :teams).first
      team_match = TeamMatch.where(match: match).first
      team = team_match.team
      td_team_name = page.find(:xpath, "/html/body/table[2]/tbody/tr[td[1]/text()=#{match.id}]/td[3]")
      expect(td_team_name).to have_text(team.name)
      expect(page).not_to have_button("Generate scores for a group B")
    end
  end

  context "when scores from group phase already exists" do
    before do
      8.times do
        FactoryBot.create(:team, group_name: "A")
        FactoryBot.create(:team, group_name: "B")
      end
      Team.where(group_name: "A").to_a.combination(2).to_a.each do |team1, team2|
        Match.create_single_match(team1, team2, "groups")
      end
      Team.where(group_name: "B").to_a.combination(2).to_a.each do |team1, team2|
        Match.create_single_match(team1, team2, "groups")
      end
      Match.all.each do |match|
        score = [[3, 0], [0, 3], [1, 1]].sample
        TeamMatch.where(match: match).first.update(score: score[0])
        TeamMatch.where(match: match).last.update(score: score[1])
      end
    end
    it "User creates pairs for playoff" do
      visit matches_path
      expect(page).to have_button.once
      click_button "Pairs for playoff"
      expect(page).to  have_xpath("/html/body/table[3]")
      best_team_group_a_id = TeamMatch.where(teams: { group_name: "A" }).group(:team_id).joins(:team).order(sum_score: :desc).limit(1).sum(:score).keys[0]
      best_team_group_a = Team.find(best_team_group_a_id).name
      forth_team_group_b_id = TeamMatch.where(teams: { group_name: "B" }).group(:team_id).joins(:team).order(sum_score: :desc).limit(4).sum(:score).keys[3]
      forth_team_group_b = Team.find(forth_team_group_b_id).name
      td_team_name = page.find(:xpath, "/html/body/table[3]/tbody/tr[td[2]/text()='#{best_team_group_a}']/td[4]")
      expect(td_team_name).to have_text(forth_team_group_b)
      expect(page).not_to have_button("Pairs for playoff")
    end
  end
  context "when pair for first playoff round are created" do
    before do
      4.times do
        FactoryBot.create(:match, :with_teams, phase: "playoff", rounds_left_playoff: 3)
      end
    end
    it "User generate scores for first playoff round" do
      visit matches_path
      expect(page).to have_button.once
      click_button "Generate scores for playoff"
       expect(page).to  have_xpath("/html/body/table[3]")
       td_with_win_score = page.find(:xpath, "/html/body/table[3]/tbody/tr[td[6]/text()='0']/td[7]", match: :first)
       expect(td_with_win_score).to have_text('3')
       expect(page).not_to have_button("Generate scores for playoff")
    end
  end
  context "after first playoff round" do
    before do
      4.times do
        FactoryBot.create(:match, :with_teams, phase: "playoff", rounds_left_playoff: 3)
      end
      Match.where(phase: "playoff", rounds_left_playoff: 3).each do |match|
        score = [[3, 0], [0, 3]].sample
        TeamMatch.where(match: match).first.update(score: score[0])
        TeamMatch.where(match: match).last.update(score: score[1])
      end
    end
    it "User wants to see semifinal pairs" do
      visit matches_path
      expect(page).to have_button.once
      click_button "Pairs for playoff semifinal"
      expect(page).to  have_xpath("/html/body/table[4]")
      winners = TeamMatch.where(team_matches: { score: 3 }, matches: {phase: "playoff", rounds_left_playoff: 3}).group(:team_id).joins(:team, :match).order(sum_score: :desc).limit(4).sum(:score).keys
      table = page.find(:xpath, "/html/body/table[4]")
      winners.each do |winner_id|
        winner = Team.find(winner_id)
        expect(table).to have_text(winner.name)
      end
      expect(page).not_to have_button("Pairs for playoff semifinal")
    end
  end

end
