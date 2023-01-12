# frozen_string_literal: true

Rails.logger = Logger.new(STDOUT)
Rails.logger.level = :INFO

require 'faker'

Info.destroy_all
Address.destroy_all
Mission.destroy_all
GroupMember.destroy_all
GroupManager.destroy_all
Group.destroy_all
Member.destroy_all
Productor.destroy_all
Document.destroy_all
Thredded::Messageboard.destroy_all
Thredded::MessageboardGroup.destroy_all

9.times do |index|
  FactoryBot.create :member,
                    :admin,
                    address: FactoryBot.create(:address),
                    email: "admin#{index}@admin.com"
end

FactoryBot.create :member,
                  :super_admin,
                  address: FactoryBot.create(:address),
                  email: 'super@admin.com'
FactoryBot.create_list :member, 30

Rails.logger.info 'Members seeded'

FactoryBot.create :group, name: 'Accueil'
FactoryBot.create :group, name: 'Gestion financière'
FactoryBot.create :group, name: 'Gestion adhérent'
FactoryBot.create :group, name: 'Coeur'
FactoryBot.create :group, name: 'Planning'
FactoryBot.create :group, name: 'Bricolage'
FactoryBot.create :group, name: 'Culture interne'
FactoryBot.create :group, name: 'Fournisseurs locaux'
FactoryBot.create :group, name: 'Autres Fournisseurs'
FactoryBot.create :group, name: 'Appovisionnement'
FactoryBot.create :group, name: 'Commande'
FactoryBot.create :group, name: 'Informatique'
redactor_group = FactoryBot.create :group, name: 'Rédacteur'

redactor_group.roles << :redactor
redactor_group.save

Member.all.each do |member|
  rand(4).times do
    FactoryBot.create :group_member,
                      member: member,
                      group: Group.all.sample
  end
end

if redactor_group.members.empty?
  FactoryBot.create :group_member,
                    member: Member.all.sample,
                    group: redactor_group
end

Group.all.each do |group|
  rand(4).times do
    FactoryBot.create :group_manager,
                      manager: group.members.sample,
                      managed_group: group
  end
end

Rails.logger.info 'Groups seeded'

FactoryBot.create :static_slot, week_day: 'Monday', week_type: 'A', start_time: DateTime.new(2020, 1, 1, 9)
FactoryBot.create :static_slot, week_day: 'Monday', week_type: 'A', start_time: DateTime.new(2020, 1, 1, 10, 30)
FactoryBot.create :static_slot, week_day: 'Thursday', week_type: 'B', start_time: DateTime.new(2020, 1, 1, 14)
FactoryBot.create :static_slot, week_day: 'Monday', week_type: 'C', start_time: DateTime.new(2020, 1, 1, 14)
FactoryBot.create :static_slot, week_day: 'Friday', week_type: 'D', start_time: DateTime.new(2020, 1, 1, 9)
FactoryBot.create :static_slot, week_day: 'Saturday', week_type: 'D', start_time: DateTime.new(2020, 1, 1, 14)

StaticSlot.all.each do |static_slot|
  FactoryBot.create :member_static_slot, static_slot: static_slot, member: Member.all.sample
end

Rails.logger.info 'static slots seeded'

10.times do
  FactoryBot.create :productor,
                    address: FactoryBot.create(:address, :coordinates)
  FactoryBot.create :productor,
                    local: true,
                    category: Productor.category.values.sample,
                    address: FactoryBot.create(:address, :coordinates)
end

Rails.logger.info 'Productors seeded'

20.times do
  begin
  FactoryBot.create :mission,
                    genre: Mission.genres.keys.sample,
                    members: Member.all.sample(rand(0..8)),
                    addresses: FactoryBot.create_list(:address, rand(1..2)),
                    author: Member.all.sample
    
  rescue ActiveRecord::RecordInvalid => e
    next
  end
end

Rails.logger.info 'Missions seeded'

FactoryBot.create_list :info, 5, author: Member.all.sample, category: Info.category.values.sample
Rails.logger.info 'Infos seeded'

5.times do
  document = Document.new
  document.category = Document.category.values.sample
  document.file.attach(io: File.open('spec/support/fixtures/erd.pdf'),
                       filename: 'erd.pdf', content_type: 'application/pdf')
  document.file_name = document.file.filename.to_s
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
