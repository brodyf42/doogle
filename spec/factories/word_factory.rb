FactoryBot.define do
  factory :word do
    sequence(:name) {|n| "testword#{n}"}

    trait :with_variant do
      after(:create) do |word|
        create(:variant, word: word)
      end
    end

    trait :with_entries do
      after(:create) do |word|
        create_list(:entry, 3, :with_definitions, word: word)
      end
    end
  end
end
