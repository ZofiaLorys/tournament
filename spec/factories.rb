# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { "test-team" }
    group_name { "C" }
  end

   factory :match do
     phase { "grupowa" }
   end

  factory :team_match do
    association :team
    association :match
  end

  # factory :match do
  #   match.reload!
  #   after :create do |match|
  #     create :team_match, match: :match 
  #   end
  # end

end
