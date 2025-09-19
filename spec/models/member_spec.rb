# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                        :bigint           not null, primary key
#  biography                 :text
#  cash_register_proficiency :integer          default("untrained")
#  confirmation_sent_at      :datetime
#  confirmation_token        :string
#  confirmed_at              :datetime
#  display_name              :string
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  first_name                :string
#  invitation_accepted_at    :datetime
#  invitation_created_at     :datetime
#  invitation_limit          :integer
#  invitation_sent_at        :datetime
#  invitation_token          :string
#  invitations_count         :integer          default(0)
#  invited_by_type           :string
#  last_name                 :string
#  moderator                 :boolean          default(FALSE)
#  phone_number              :string
#  remember_created_at       :datetime
#  reset_password_sent_at    :datetime
#  reset_password_token      :string
#  role                      :integer          default("member")
#  unconfirmed_email         :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  invited_by_id             :bigint
#  register_id               :integer
#
# Indexes
#
#  index_members_on_confirmation_token                 (confirmation_token)
#  index_members_on_email                              (email) UNIQUE
#  index_members_on_invitation_token                   (invitation_token) UNIQUE
#  index_members_on_invitations_count                  (invitations_count)
#  index_members_on_invited_by_id                      (invited_by_id)
#  index_members_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_members_on_reset_password_token               (reset_password_token) UNIQUE
#  members_display_name_lower                          (lower((display_name)::text) text_pattern_ops) UNIQUE
#

require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'Model instanciation' do
    subject(:instance) { described_class.new }

    describe 'associations' do
      it { is_expected.to accept_nested_attributes_for(:address).allow_destroy(true) }
      it { is_expected.to have_one(:address).dependent(:destroy) }
      it { is_expected.to have_many(:missions).through(:enrollments) }
      it { is_expected.to have_many(:history_of_static_slot_selections) }
      it { is_expected.to have_many(:groups).through(:group_members) }
      it { is_expected.to have_many(:static_slots).through(:member_static_slots) }

      it {
        expect(instance).to have_many(:created_missions).class_name('Mission')
                                                        .with_foreign_key('author_id')
                                                        .dependent(:nullify)
      }

      it {
        expect(instance).to have_many(:managed_groups).class_name('Group')
                                                      .through(:group_managers)
                                                      .with_foreign_key('manager_id')
                                                      .dependent(:nullify)
      }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_presence_of(:display_name) }
    end
  end

  describe '#set_unique_display_name' do
    let(:member) { create :member }

    it 'sets the display_name attribute on creation' do
      new_member = build :member
      new_member.save
      expect(new_member.reload.display_name).to eq "#{new_member.first_name} #{new_member.last_name}"
    end

    context 'when a pre-existing member without :display_name is updated' do
      it 'sets a display_name' do
        old_member = build :member
        old_member.save(validate: false)

        old_member.reload.save

        expect(old_member.display_name).to eq "#{old_member.first_name} #{old_member.last_name}"
      end
    end

    context 'when a member is created with already existing first_name and last_name,' do
      it 'checks uniqueness of :display_name by appending it a number' do
        new_member = create :member, first_name: member.first_name,
                                     last_name: member.last_name
        expect(new_member.display_name).to eq "#{new_member.first_name} #{new_member.last_name} 1"
      end

      it 'checks uniqueness of :display_name by appending it an incrementing number' do
        create :member, first_name: member.first_name,
                        last_name: member.last_name
        new_member = create :member, first_name: member.first_name,
                                     last_name: member.last_name
        expect(new_member.display_name).to eq "#{new_member.first_name} #{new_member.last_name} 2"
      end
    end

    context 'when a member updates, without changing his/her name' do
      it 'does not change :display_name' do
        member = create :member
        display_name = member.display_name
        member.update(phone_number: 'whatever')
        expect(member.reload.display_name).to eq display_name
      end
    end

    context 'when a member updates, and the name is edited,' do
      let(:first_name) { 'new' }
      let(:last_name) { 'name' }

      before do
        member.first_name = first_name
        member.last_name = last_name
      end

      it 'update :display_name accordingly' do
        member.save
        expect(member.reload.display_name).to eq "#{first_name} #{last_name}"
      end

      it 'appends an number to :display_name if it already exists' do
        create :member, first_name: first_name, last_name: last_name
        member.save
        expect(member.reload.display_name).to eq "#{first_name} #{last_name} 1"
      end
    end
  end

  describe '#thredded_admin? (forum admin rights)' do
    context 'when member is super admin,' do
      subject { build_stubbed :member, :super_admin }

      it { is_expected.to be_thredded_admin }
    end

    context 'when member is an admin,' do
      subject { build_stubbed :member, :admin }

      it { is_expected.to be_thredded_admin }
    end

    context 'when member is not an admin' do
      subject { build_stubbed :member }

      it { is_expected.not_to be_thredded_admin }
    end
  end

  describe '#monthly_worked_hours' do
    subject(:monthly_worked_hours) { member.monthly_worked_hours(Date.current) }

    let(:member) { create :member, register_id: 1234 }

    before { allow(Date).to receive(:current).and_return(Date.new(2021, 6, 15)) }

    it 'sums the worked hours during the month of the given date' do
      create :enrollment, member: member
      expect(monthly_worked_hours).to eq 3
    end

    it 'does not sum the worked hours during the years outside of the given date' do
      last_year_mission = create :mission, start_date: Date.current - 1.year
      create :enrollment, mission: last_year_mission, member: member

      expect(monthly_worked_hours).to eq 0
    end

    it 'does not sum worked hours of other members' do
      create_list :enrollment, 4
      create :enrollment, member: member

      expect(monthly_worked_hours).to eq 3
    end

    context 'when a member shares the same register_id with his/her family' do
      let(:family_member) { create :member, register_id: 1234 }

      it "affects every family members' worked hours count" do
        create :enrollment, member: family_member

        expect(monthly_worked_hours)
          .to eq family_member.monthly_worked_hours(Date.current)
      end
    end

    context 'when a member is enrolled on an event' do
      let(:event) { create :mission, genre: 'event' }

      it 'ignores these hours' do
        create :enrollment, member: member
        create :enrollment, member: member, mission: event

        expect(monthly_worked_hours).to eq 3
      end
    end
  end
end
