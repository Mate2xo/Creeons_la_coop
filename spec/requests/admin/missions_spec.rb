# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'A Missions admin request', type: :request do
  before { sign_in create :member, :super_admin }

  describe '#generate_schedule' do
    subject(:post_generate_schedule) { post generate_schedule_admin_missions_path(3) }

    before do
      allow(DateTime).to receive(:current).and_return DateTime.new(2020, 12, 10)
    end

    context 'when all schedules asked has been already generated' do
      it 'notices that the schedule has already been generated' do
        create_history_of_generated_schedule_for_n_months(3)
        post_generate_schedule
        follow_redirect!

        expect(response.body).to include(I18n.t('admin.missions.generate_schedule.schedule_already_generated'))
      end
    end
  end

  def create_history_of_generated_schedule_for_n_months(months_count)
    (1..months_count).each do |n|
      create :history_of_generated_schedule,
             month_number: (DateTime.current + n.month).at_beginning_of_month
    end
  end
end
