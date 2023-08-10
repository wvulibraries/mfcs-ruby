# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.new(
  :id => 100,
  :username => 'admin',
  :email => 'changeme@mail.wvu.edu',
  :password => 'password',
  :password_confirmation => 'password',
  :first_name => 'Admin',
  :last_name => 'Account',
  :status => 'admin',
  :student => false,
  :active => true,
  :form_creator => true,
  :created_at => Time.now,
  :updated_at => Time.now
)

user.save!