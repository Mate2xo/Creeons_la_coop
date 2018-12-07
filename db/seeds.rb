# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
Info.destroy_all
Mission.destroy_all
Member.destroy_all
Productor.destroy_all
Address.destroy_all 

30.times do
  Address.create!(
    postal_code: Faker::Address.zip,
    city: Faker::Address.city,
    street_name_1: Faker::Address.street_address,
    street_name_2: Faker::Address.secondary_address
  )
end

1.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  member = Member.create(
    email: "admin@admin.fr",
    password: "password",
    first_name: first_name,
    last_name: last_name,
    biography: Faker::RickAndMorty.quote,
    phone_number: Faker::PhoneNumber.phone_number,
    role: "admin"  
  )
  member.address = Address.find( rand((Address.first.id)..(Address.first.id + 9)) )
end

1.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  member = Member.create(
    email: "super@admin.fr",
    password: "password",
    first_name: first_name,
    last_name: last_name,
    biography: Faker::RickAndMorty.quote,
    phone_number: Faker::PhoneNumber.phone_number,
    role: "super_admin"  
  )
  member.address = Address.find( rand((Address.first.id)..(Address.first.id + 9)) )
end


10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  member = Member.create(
    email: Faker::Internet.free_email(first_name),
    password: "password",
    first_name: first_name,
    last_name: last_name,
    biography: Faker::RickAndMorty.quote,
    phone_number: Faker::PhoneNumber.phone_number,
    role: "membre"  
  )
  member.address = Address.find( rand((Address.first.id)..(Address.first.id + 9)) )
end

10.times do
  productor = Productor.create(
    name: Faker::Company.name,
    description: Faker::Company.bs,
    phone_number: Faker::PhoneNumber.phone_number
  )
  productor.address = Address.find( rand((Address.first.id + 10)..(Address.first.id + 19)) )
end

10.times do
  mission = Mission.create!(
    name: Faker::Movie.quote,
    description: "Get some #{Faker::Food.vegetables}, and some #{Faker::Food.fruits}",
    due_date: Faker::Date.forward(20),
  )
  mission.addresses << Address.find( rand((Address.first.id + 10)..(Address.first.id + 29)) )
  mission.members << Member.take( rand(Member.count) )
end

5.times do
  Info.create!(
    title: Faker::Lorem.sentence,
    content: Faker::Lorem.paragraphs
  )
end
