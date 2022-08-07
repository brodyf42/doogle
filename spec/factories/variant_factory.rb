FactoryBot.define do
  factory :variant do
    word
    sequence(:name) {|n| "testvariant#{n}"}
  end
end
