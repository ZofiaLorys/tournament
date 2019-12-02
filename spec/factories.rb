# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Team.name }
    group_name { "C" }
  end

  factory :match do
    phase { "grupowa" }
    trait :with_teams do
      after :create do |match|
        create_list :team_match, 2, match: match
      end
    end
  end

  factory :team_match do
    association :team
    association :match
  end
end
