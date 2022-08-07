FactoryBot.define do
  factory :entry do
    word
    function { 'test function' }

    trait :with_definitions do
      after(:create) do |entry|
        create_list(:definition, 3, entry: entry)
      end
    end
  end
end
