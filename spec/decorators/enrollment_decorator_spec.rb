# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnrollmentDecorator do
  let(:current_time) { DateTime.new(2020, 1, 1, 9) }

  describe '#already_taken?' do
    context 'when the time slot is in enrollment range' do
      it 'return true' do
        enrollment = create :enrollment, start_time: current_time, end_time: current_time + 1.5.hours
        time_slot = current_time

        response = enrollment.decorate.already_taken?(time_slot)

        expect(response).to be true
      end
    end

    context 'when the time slot is not in enrollment range' do
      it 'return false' do
        enrollment = create :enrollment, start_time: current_time, end_time: current_time + 1.5.hours
        time_slot = current_time + 1.5.hours

        response = enrollment.decorate.already_taken?(time_slot)

        expect(response).to be false
      end
    end

    context 'when the enrollment has not an id' do
      it 'return false' do
        enrollment = build :enrollment
        time_slot = current_time

        response = enrollment.decorate.already_taken?(time_slot)

        expect(response).to be false
      end
    end
  end
end
