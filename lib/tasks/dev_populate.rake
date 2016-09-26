require 'factory_girl'

def create_dummies(model, *args, count: 1)
  puts "Creating #{count} #{model.to_s.pluralize(count)} records#{" (args: #{args})" if args.any?}..."
  count.times { FactoryGirl.create(model, *args) }
end

namespace :dev do
  desc "Populate the development DB with dummy records"
  task populate: :environment do
    FactoryGirl.find_definitions
    User.connection.transaction do
      create_dummies :user, count: 10

      create_dummies :conference, count: 10
      create_dummies :course, count: 10
      create_dummies :ministry, count: 10
      create_dummies :housing_facility_with_rooms, count: 10
      create_dummies :family_with_members, count: 10
    end
  end
end
