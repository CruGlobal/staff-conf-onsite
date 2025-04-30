FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    role { User::ROLES.sample }
    guid { Faker::Number.hexadecimal(digits: 8) }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
  
    factory :admin_user do
      role { 'admin' }
    end

    factory :general_user do
      role { 'general' }
    end

    factory :finance_user do
      role { 'finance' }
    end

    factory :read_only_user do
      role { 'read_only' }
    end
  end
end
