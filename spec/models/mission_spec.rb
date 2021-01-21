# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id                :bigint(8)        not null, primary key
#  name              :string           not null
#  description       :text             not null
#  due_date          :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  author_id         :bigint(8)
#  start_date        :datetime
#  recurrent         :boolean
#  max_member_count  :integer
#  min_member_count  :integer
#  delivery_expected :boolean          default(FALSE)
#  event             :boolean          default(FALSE)
#

# A Mission is an activity that has to be done for the Supermaket Team to function properly.
# Every member can create a mission
# Available methods: #addresses, #author, #due_date, #name, #description
# A regulated mission have several time_slots
# A time slot is a subdivision of mission duration
# A time slot last 90 minutes
# A time slot have several slots
# Slots count for a time slot is equal to :max_member_count
require 'rails_helper'

RSpec.describe Mission, type: :model do
  let(:mission) { build(:mission) }

  describe 'Model instanciation' do
    subject { described_class.new }

    describe 'Database' do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:description).of_type(:text).with_options(null: false) }
      it { is_expected.to have_db_column(:due_date).of_type(:datetime) }
      it { is_expected.to have_db_column(:min_member_count).of_type(:integer) }
      it { is_expected.to have_db_column(:max_member_count).of_type(:integer) }
      it { is_expected.to have_db_index(:author_id) }
    end

    describe 'validations' do
      it { is_expected.to accept_nested_attributes_for(:addresses).allow_destroy(true) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:min_member_count) }
      it { is_expected.to validate_presence_of(:genre) }
      it { is_expected.to validate_numericality_of(:min_member_count).only_integer }
      it { is_expected.to validate_numericality_of(:max_member_count).only_integer.allow_nil }
    end

    describe 'associations' do
      it { is_expected.to belong_to(:author).class_name('Member').inverse_of('created_missions').optional }
      it { is_expected.to have_many(:members).through(:enrollments) }
      it { is_expected.to have_and_belong_to_many(:productors) }
      it { is_expected.to have_and_belong_to_many(:addresses) }
    end
  end

  describe '#selectable_time_slots' do
    it 'returns the time slots with at least one slot available' do
      mission = create :mission, genre: 'regulated'

      time_slots = mission.selectable_time_slots

      expect(time_slots).to eq([mission.start_date, mission.start_date + 90.minutes])
    end

    context 'when all slots are already taken by other members' do
      it 'returns no time slots' do
        mission = create :mission, genre: 'regulated'
        enroll_n_members_on_mission(mission, 4)

        response = mission.selectable_time_slots

        expect(response).to be_empty
      end
    end
  end

  def enroll_n_members_on_mission(mission, members_count)
    members = create_list :member, members_count
    members.each do |member|
      create :enrollment,
             member: member,
             mission: mission,
             start_time: mission.start_date,
             end_time: mission.start_date + 3.hours
    end
  end
end
