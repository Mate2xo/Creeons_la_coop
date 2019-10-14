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
FactoryBot.create :member, :super_admin,
                  address: FactoryBot.create(:address),
                  email: "super@admin.com"
FactoryBot.create_list :member, 30
puts "Members seeded"

10.times {
  FactoryBot.create :productor, address: FactoryBot.create(:address, :coordinates)
  FactoryBot.create :productor, local: true,
                                address: FactoryBot.create(:address, :coordinates)
}
puts "Productors seeded"

10.times {
  FactoryBot.create :mission, members: Member.take(rand(0..8)),
                              addresses: FactoryBot.create_list(:address, rand(1..2))
}
puts "Missions seeded"

FactoryBot.create_list :info, 5
puts "Infos seeded"

FactoryBot.create_list :messageboard_group, 2
FactoryBot.create_list :messageboard, 6,
                       messageboard_group_id: Thredded::MessageboardGroup.all.sample.id

18.times {
  FactoryBot.create :topic, with_posts: rand(1..4),
                            messageboard: Thredded::Messageboard.all.sample
}
puts "Forum seeded"

puts "Database seed OK. App is ready to use"
