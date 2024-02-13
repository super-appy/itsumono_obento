FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}"}
    sequence(:email) { |n| "use_#{n}@example.com"}
    password { "password" }
    password_confirmation { "password" }
    line_registerd {0}
  end
end
