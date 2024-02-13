FactoryBot.define do
  factory :lunchbox_log do
    cooked_date { Date.today }
    original_menu { "test_menu" }
    comment { "test_comment" }
    published_status {2}
    association :user
  end
end