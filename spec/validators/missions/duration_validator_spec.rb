# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/support/shared_examples')

RSpec.describe Missions::DurationValidator do
  context 'with a :standard mission' do
    subject(:mission) { build(:mission, genre: :standard, start_date:, due_date:) }

    context 'with a negative duration' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date - 3.minutes }

      it { is_expected.not_to be_valid }

      it 'sets a :minimum error' do
        mission.valid?
        expect(mission.errors).to be_of_kind :duration, :minimum
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { mission }
      end
    end

    context 'with a positive duration' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date + 3.minutes }

      it { is_expected.to be_valid }
    end

    context 'with a duration greater than 16 hours' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date + 17.hours }

      it { is_expected.not_to be_valid }

      it 'sets a :maximum error' do
        mission.valid?
        expect(mission.errors).to be_of_kind :duration, :maximum
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { mission }
      end
    end
  end

  context 'with a :shipping mission' do
    subject(:mission) { build(:mission, genre: :shipping, start_date:, due_date:) }

    context 'with a negative duration' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date - 3.minutes }

      it { is_expected.not_to be_valid }

      it 'sets a :minimum error' do
        mission.valid?
        expect(mission.errors).to be_of_kind :duration, :minimum
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { mission }
      end
    end

    context 'with a positive duration' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date + 3.minutes }

      it { is_expected.to be_valid }
    end

    context 'with a duration greater than 16 hours' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date + 17.hours }

      it { is_expected.not_to be_valid }

      it 'sets a :maximum error' do
        mission.valid?
        expect(mission.errors).to be_of_kind :duration, :maximum
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { mission }
      end
    end
  end

  context 'with an :event mission' do
    subject(:mission) { build(:mission, genre: :event, start_date:, due_date:) }

    context 'with a negative duration' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date - 3.minutes }

      it { is_expected.not_to be_valid }

      it 'sets a :minimum error' do
        mission.valid?
        expect(mission.errors).to be_of_kind :duration, :minimum
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { mission }
      end
    end

    context 'with a positive duration' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date + 3.minutes }

      it { is_expected.to be_valid }
    end

    context 'with a duration greater than 16 hours' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date + 36.hours }

      it { is_expected.to be_valid }
    end
  end

  context 'with a :regulated mission' do
    subject(:mission) { build(:mission, genre: :regulated, start_date:, due_date:) }

    context 'with a negative duration' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date - 3.minutes }

      it { is_expected.not_to be_valid }

      it 'sets a :minimum error' do
        mission.valid?
        expect(mission.errors).to be_of_kind :duration, :minimum
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { mission }
      end
    end

    context 'with a duration greater than 16 hours' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date + 17.hours }

      it { is_expected.not_to be_valid }

      it 'sets a :maximum error' do
        mission.valid?
        expect(mission.errors).to be_of_kind :duration, :maximum
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { mission }
      end
    end

    context 'with a duration of 90 minutes' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date + 90.minutes }

      it { is_expected.to be_valid }
    end

    context 'with a duration not being a multiple of 90 minutes' do
      let(:start_date) { DateTime.new 2025, 9, 3, 16, 30 }
      let(:due_date) { start_date + 91.minutes }

      it { is_expected.not_to be_valid }

      it 'sets a :duration_is_not_a_multiple_of_90_minutes error' do
        mission.valid?
        expect(mission.errors).to be_of_kind :duration, :multiple
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { mission }
      end
    end
  end
end
