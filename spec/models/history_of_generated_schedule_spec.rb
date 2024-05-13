# frozen_string_literal: true

# == Schema Information
#
# Table name: history_of_generated_schedules
#
#  id           :bigint           not null, primary key
#  month_number :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe HistoryOfGeneratedSchedule, type: :model do
  describe 'Model instanciation' do
    describe 'validations' do
      it { is_expected.to validate_presence_of(:month_number) }
    end
  end
end
