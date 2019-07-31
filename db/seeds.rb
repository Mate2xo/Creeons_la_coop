# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
Info.destroy_all
Address.destroy_all
Mission.destroy_all
Member.destroy_all
Productor.destroy_all

60.times do
  Address.create!(
    postal_code: Faker::Address.zip,
    city: Faker::Address.city,
    street_name_1: Faker::Address.street_address,
    street_name_2: Faker::Address.secondary_address
  )
end
puts "Addresses seeded"

# i is a counter that helps assigning distinct addresses
i = Address.first.id

9.times do |index|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  member = Member.new(
    email: "admin#{index}@admin.com",
    password: "password",
    first_name: first_name,
    last_name: last_name,
    biography: Faker::RickAndMorty.quote,
    phone_number: Faker::PhoneNumber.phone_number,
    role: "admin",
    group: [0, 1, 2, 3, 4, 5, 6].sample
  )
  member.address = Address.find(i)
  member.skip_confirmation!
  member.save
  i += 1
end

# i += 10
1.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  member = Member.new(
    email: "super@admin.com",
    password: "password",
    first_name: first_name,
    last_name: last_name,
    biography: Faker::RickAndMorty.quote,
    phone_number: Faker::PhoneNumber.phone_number,
    role: "super_admin",
    group: [0, 1, 2, 3, 4, 5, 6].sample
  )
  member.address = Address.find(i)
  member.skip_confirmation!
  member.save
  i += 1
end

# i += 11
30.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  member = Member.new(
    email: Faker::Internet.free_email(first_name),
    password: "password",
    first_name: first_name,
    last_name: last_name,
    biography: Faker::RickAndMorty.quote,
    phone_number: Faker::PhoneNumber.phone_number,
    role: "member",
    group: [0, 1, 2, 3, 4, 5, 6].sample
  )
  member.address = Address.find(i)
  member.skip_confirmation!
  member.save
  i += 1
end
puts "Members seeded"

# i += 41
10.times do
  productor = Productor.new(
    name: Faker::Company.name,
    description: Faker::Company.bs,
    phone_number: Faker::PhoneNumber.phone_number,
    website_url: Faker::Internet.url
  )
  productor.address = Address.find(i)
  productor.managers << Member.where(role: 'admin').take( rand(1..3) )
  productor.save
  i += 1
end

# i += 51
10.times do
  productor = Productor.new(
    name: Faker::Company.name,
    description: Faker::Company.bs,
    phone_number: Faker::PhoneNumber.phone_number,
    website_url: Faker::Internet.url,
    local: true
  )
  productor.address = Address.find(i)
  productor.managers << Member.where(role: 'admin').take( rand(1..3) )
  productor.save
  i += 1
end
puts "Productors seeded"

# i += 61
5.times do
  start_date = Faker::Time.forward(20, :morning)
  mission = Mission.new(
    name: Faker::Movie.quote,
    description: "Get some #{Faker::Food.vegetables}, and some #{Faker::Food.fruits}",
    max_member_count: rand(4..8),
    min_member_count: rand(3),
    start_date: start_date,
    due_date: start_date + 7200,
    recurrent: true
  )
  mission.addresses << Address.find( rand((Productor.first.address.id)..(Productor.first.address.id)) )
  mission.members << Member.take( rand(mission.max_member_count) )
  mission.author = Member.find( rand((Member.first.id)..(Member.last.id)) )
  mission.save
end

5.times do
  mission = Mission.new(
    name: Faker::Movie.quote,
    description: "Get some #{Faker::Food.vegetables}, and some #{Faker::Food.fruits}",
    max_member_count: rand(4..8),
    min_member_count: rand(3),
    start_date: Faker::Time.forward(20, :morning),
    recurrent: false
  )
  mission.addresses << Address.find( rand((Productor.first.address.id)..(Productor.first.address.id)) )
  mission.members << Member.take( rand(mission.max_member_count) )
  mission.author = Member.find( rand((Member.first.id)..(Member.last.id)) )
  mission.save
end
puts "Missions seeded"

5.times do
  info = Info.new(
    title: Faker::Lorem.sentence,
    content: Faker::Lorem.paragraphs
  )
  info.author = Member.where(role: "admin")[rand(0..9)]
  info.save
end
puts "Infos seeded"
