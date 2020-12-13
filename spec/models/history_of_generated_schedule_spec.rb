# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HistoryOfGeneratedSchedule, type: :model do
  describe 'Model instanciation' do
    describe 'validations' do
      it { is_expected.to validate_presence_of(:month_of_generated_schedule) }
    end
  end
end
