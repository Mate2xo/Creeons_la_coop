require 'rails_helper'

describe EnrollmentPresenter do
  describe '#default_start_time' do
    subject(:default_start_time) { described_class.new(enrollment).default_start_time }

    let(:enrollment) { build_stubbed(:enrollment) }

    it 'return nil' do
      expect(default_start_time).to be_nil
    end

    context 'when there is a start time' do
      let(:enrollment) { build_stubbed(:enrollment, start_time: Time.zone.parse('10h53')) }

      it 'formats it in the Hour:Minute format' do
        expect(default_start_time).to eq '10:53'
      end
    end
  end

  describe '#default_end_time' do
    subject(:default_end_time) { described_class.new(enrollment).default_end_time }

    let(:enrollment) { build_stubbed(:enrollment) }

    it 'return nil' do
      expect(default_end_time).to be_nil
    end

    context 'when there is a start time' do
      let(:enrollment) { build_stubbed(:enrollment, end_time: Time.zone.parse('19h35')) }

      it 'formats it in the Hour:Minute format' do
        expect(default_end_time).to eq '19:35'
      end
    end
  end
end
