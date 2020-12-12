require 'rails_helper'
require 'draper/test/rspec_integration'

RSpec.describe StaticSlotDecorator do
  describe '#full_display' do
    context 'when hours.min < 10' do
      let(:static_slot) { (create :static_slot).decorate }

      it 'displays correctly the hours' do
        expect(static_slot.full_display).to eq "#{I18n.t('activerecord.attributes.static_slot.week_days.Monday')} 9h00 #{I18n.t('active_admin.resource.show.week')} A"
      end
    end

    context 'when hours.min >= 10' do
      let(:static_slot) { (create :static_slot, start_time: DateTime.new(2020, 1, 1, 9, 20)).decorate }

      it 'displays correctly the hours' do
        expect(static_slot.full_display).to eq "#{I18n.t('activerecord.attributes.static_slot.week_days.Monday')} 9h20 #{I18n.t('active_admin.resource.show.week')} A"
      end
    end
  end
end
