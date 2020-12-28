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

Member.all.each do |member|
  rand(4).times do
    FactoryBot.create :group_member,
                      member: member,
                      group: Group.all.sample
  end
end

Group.all.each do |group|
  rand(4).times do
    FactoryBot.create :group_manager,
                      manager: group.members.sample,
                      managed_group: group
  end
end

Rails.logger.info 'Groups seeded'

10.times do
  FactoryBot.create :productor,
                    address: FactoryBot.create(:address, :coordinates)
  FactoryBot.create :productor,
                    local: true,
                    address: FactoryBot.create(:address, :coordinates)
end

Rails.logger.info 'Productors seeded'

10.times do
  FactoryBot.create :mission,
                    members: Member.all.sample(rand(0..8)),
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
