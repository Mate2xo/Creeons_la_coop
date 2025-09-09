# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id                               :bigint           not null, primary key
#  name                             :string           not null
#  description                      :text             not null
#  due_date                         :datetime
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  author_id                        :bigint
#  start_date                       :datetime
#  recurrent                        :boolean
#  max_member_count                 :integer
#  min_member_count                 :integer
#  delivery_expected                :boolean          default(FALSE)
#  genre                            :integer          default("standard")
#  cash_register_close_out_required :boolean          default(FALSE), not null
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

RSpec.describe Mission do
  let(:mission) { build(:mission) }

  it { is_expected.to accept_nested_attributes_for(:addresses).allow_destroy(true) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:min_member_count) }
  it { is_expected.to validate_presence_of(:genre) }
  it { is_expected.to validate_numericality_of(:min_member_count).only_integer }
  it { is_expected.to validate_numericality_of(:max_member_count).only_integer.allow_nil }

  it { is_expected.to belong_to(:author).class_name('Member').inverse_of('created_missions').optional }
  it { is_expected.to have_many(:members).through(:enrollments) }
  it { is_expected.to have_and_belong_to_many(:productors) }
  it { is_expected.to have_and_belong_to_many(:addresses) }

  describe '#selectable_time_slots' do
    subject(:selectable_time_slots) { mission.selectable_time_slots }

    let(:mission) { create(:mission, :regulated) }

    it 'returns the time slots that a member can enroll in' do
      expect(selectable_time_slots).to eq([mission.start_date, mission.start_date + Enrollment::TIME_SLOT_DURATION])
    end

    context 'when all slots are already taken by other members' do
      let(:mission) do
        create(:mission, :regulated, max_member_count: 2) do |mission|
          # Fill both 90-min slots with 2 members each
          mission.selectable_time_slots.each do |slot_start|
            2.times do
              member = create(:member, :beginner)
              create(:enrollment, mission:, member:, start_time: slot_start, end_time: slot_start + Enrollment::TIME_SLOT_DURATION)
            end
          end
        end
      end

      it { is_expected.to be_empty }
    end

    context 'with a non-regulated mission' do
      let(:mission) { build(:mission) }

      it 'returns nil' do
        expect(selectable_time_slots).to be_nil
      end
    end
  end

  describe '#time_slot_already_taken_by_member?' do
    subject(:time_slot_already_taken_by_member?) do
      mission.time_slot_already_taken_by_member?(time_slot, member)
    end

    let(:mission) { build(:mission) }
    let(:member) { build(:member) }
    let(:time_slot) { DateTime.current }

    it { is_expected.to be false }

    context 'with a member enrolled on this mission during the given time slot' do
      let(:mission) do
        create(:mission, start_date: time_slot - 1.hour) do |mission|
          create(:enrollment,
                 member: member,
                 mission: mission,
                 start_time: time_slot - 1.hour,
                 end_time: time_slot + 1.hour)
        end
      end

      it { is_expected.to be true }
    end

    context 'with a member enrolled on this mission outside of the given time slot' do
      let(:mission) do
        create(:mission, start_date: time_slot - 2.hours) do |mission|
          create(:enrollment,
                 member: member,
                 mission: mission,
                 start_time: time_slot - 1.hour,
                 end_time: time_slot)
        end
      end

      it { is_expected.to be false }
    end
  end
end
