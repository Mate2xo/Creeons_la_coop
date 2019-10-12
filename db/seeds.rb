# frozen_string_literal: true

require 'faker'

Info.destroy_all
Address.destroy_all
Mission.destroy_all
Member.destroy_all
Productor.destroy_all
Thredded::Messageboard.destroy_all
Thredded::MessageboardGroup.destroy_all

9.times do |index|
  FactoryBot.create :member, :admin,
                             address: FactoryBot.create(:address),
                             email: "admin#{index}@admin.com"
end

FactoryBot.create :member, :admin,
                           address: FactoryBot.create(:address),
                           email: "super@admin.com"
FactoryBot.create_list :member, 30
puts "Members seeded"

FactoryBot.create_list :productor, 10,
                                   address: FactoryBot.create(:address, :coordinates)
FactoryBot.create_list :productor, 10,
                                   address: FactoryBot.create(:address, :coordinates),
                                   local:true
puts "Productors seeded"

FactoryBot.create_list :mission, 10,
                                 addresses: FactoryBot.create_list(:address, rand(1..2)),
                                 members: Member.take(rand(0..8))
puts "Missions seeded"

FactoryBot.create_list :info, 5
puts "Infos seeded"

FactoryBot.create_list :messageboard_group, 2
FactoryBot.create_list :messageboard, 6,
                                      messageboard_group_id: Thredded::MessageboardGroup.all.sample.id
FactoryBot.create_list :topic, 18,
                               messageboard: Thredded::Messageboard.all.sample,
                               with_posts: rand(1..4)

puts "Database seed OK. App is ready to use"
