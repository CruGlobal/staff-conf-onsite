# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Rails.env.production?
  # Example role accounts
  User.create!(role: 'admin', email: 'admin@example.com')
  User.create!(role: 'finance', email: 'finance@example.com')
  User.create!(role: 'general', email: 'general@example.com')

  # Developer accounts
  User.create!(role: 'admin', email: 'jon.sangster@ballistiq.com')
  User.create!(role: 'admin', email: 'tyler@ballistiq.com')
end
