FactoryBot.define do
  factory :notification do
    visiter_id { 1 }
    visited_id { 1 }
    action { "follow" }
  end
end
