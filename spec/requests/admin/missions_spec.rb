# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'A Missions admin request', type: :request do
  before { sign_in create :member, :super_admin }

  describe '#generate_schedule' do
    context 'when a schedule has been already generated' do
      subject(:post_generate_schedule) { post generate_schedule_admin_missions_path }

      before do
        allow(DateTime).to receive(:current).and_return DateTime.new(2020, 12, 10)
      end

      it 'notices that the schedule has already been generated' do
        create :history_of_generated_schedule,
               month_number: (DateTime.current + 1.month).at_beginning_of_month

        post_generate_schedule
        follow_redirect!

        expect(response.body).to include(I18n.t('admin.missions.generate_schedule.schedule_already_generated'))
      end
    end
  end
end
