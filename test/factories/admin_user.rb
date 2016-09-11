FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    role { AdminUser::ROLES.sample }

    factory :admin_user do
      role 'admin'
    end

    factory :general_user do
      role 'general'
    end

    factory :finance_user do
      role 'finance'
    end
  end
end
