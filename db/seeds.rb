# frozen_string_literal: true

require 'faker'

Info.destroy_all
Address.destroy_all
Mission.destroy_all
GroupMember.destroy_all
Group.destroy_all
Member.destroy_all
Productor.destroy_all
Document.destroy_all
Thredded::Messageboard.destroy_all
Thredded::MessageboardGroup.destroy_all

9.times do |index|
  FactoryBot.create :member, :admin,
                    address: FactoryBot.create(:address),
                    email: "admin#{index}@admin.com"
end

FactoryBot.create :member, :super_admin,
                  address: FactoryBot.create(:address),
                  email: 'super@admin.com'
FactoryBot.create_list :member, 30

Rails.logger.info 'Members seeded'

FactoryBot.create :group, :with_group_manager_mail, name: 'welcome'
FactoryBot.create :group, name: 'financial_management'
FactoryBot.create :group, name: 'members_management'
FactoryBot.create :group, name: 'core'
FactoryBot.create :group, name: 'schedule'
FactoryBot.create :group, name: 'diy'
FactoryBot.create :group, name: 'internal_culture'
FactoryBot.create :group, name: 'local_suppliers'
FactoryBot.create :group, name: 'other_suppliers'
FactoryBot.create :group, name: 'supply'
FactoryBot.create :group, name: 'orders_management'
FactoryBot.create :group, name: 'it'

Member.all.each do |member|
  rand(4).times do
    FactoryBot.create :group_member, member: member, group: Group.all.sample
  end
end

Rails.logger.info 'groups seeded'

10.times do
  FactoryBot.create :productor, address: FactoryBot.create(:address, :coordinates)
  FactoryBot.create :productor, local: true,
    address: FactoryBot.create(:address, :coordinates)
end

Rails.logger.info 'Productors seeded'

10.times do
  FactoryBot.create :mission, members: Member.all.sample(rand(0..8)),
  addresses: FactoryBot.create_list(:address, rand(1..2)),
  author: Member.all.sample
end

Rails.logger.info 'Missions seeded'

FactoryBot.create_list :info, 5, author: Member.all.sample
Rails.logger.info 'Infos seeded'

5.times do
  document = Document.new
  document.file.attach(io: File.open('spec/support/fixtures/erd.pdf'),
                       filename: 'erd.pdf', content_type: 'application/pdf')
  document.save!
end

Rails.logger.info 'Documents seeded'

FactoryBot.create_list :messageboard_group, 2
FactoryBot.create_list :messageboard, 6,
  messageboard_group_id: Thredded::MessageboardGroup.all.sample.id

18.times do
  FactoryBot.create :topic, with_posts: rand(1..4),
  messageboard: Thredded::Messageboard.all.sample
end

Rails.logger.info 'Forum seeded'

Rails.logger.info 'Database seed OK. App is ready to use'
