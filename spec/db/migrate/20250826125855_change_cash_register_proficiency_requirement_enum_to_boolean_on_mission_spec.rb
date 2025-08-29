# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('db/migrate/20250826125855_change_cash_register_proficiency_requirement_enum_to_boolean_on_mission.rb')

RSpec.describe ChangeCashRegisterProficiencyRequirementEnumToBooleanOnMission do
  let(:migrations) { ActiveRecord::MigrationContext.new(ActiveRecord::Migrator.migrations_paths).migrations }

  context 'when migrating' do
    subject(:up) do
      ActiveRecord::Migrator
        .new(:up,
             migrations,
             ActiveRecord::Base.connection.schema_migration,
             ActiveRecord::Base.connection.internal_metadata,
             20_250_826_125_855)
    end

    around do |example|
      ActiveRecord::Migration.suppress_messages do
        ActiveRecord::Migrator
          .new(:down,
               migrations,
               ActiveRecord::Base.connection.schema_migration,
               ActiveRecord::Base.connection.internal_metadata,
               20_250_519_103_908)
          .migrate

        Mission.reset_column_information
        example.run
        Mission.reset_column_information
      end
    end

    context 'with a Mission having a :beginner enum requirement' do
      let!(:mission) { create(:mission, cash_register_proficiency_requirement: :beginner) }

      it 'migrates it to a false boolean' do
        up.migrate
        expect(mission.reload.cash_register_close_out_required).to be false
      end
    end

    context 'with a Mission having a :proficient enum requirement' do
      let!(:mission) { create(:mission, cash_register_proficiency_requirement: 2) }

      it 'migrates it to a true boolean' do
        up.migrate
        expect(mission.reload.cash_register_close_out_required).to be true
      end
    end
  end

  context 'when rolling back' do
    subject(:down) do
      ActiveRecord::Migrator
        .new(:down,
             migrations,
             ActiveRecord::Base.connection.schema_migration,
             ActiveRecord::Base.connection.internal_metadata,
             20_250_519_103_908)
    end

    around do |example|
      ActiveRecord::Migration.suppress_messages do
        example.run

        ActiveRecord::Migrator
          .new(:up,
               migrations,
               ActiveRecord::Base.connection.schema_migration,
               ActiveRecord::Base.connection.internal_metadata)
          .migrate
      end
      Mission.reset_column_information
    end

    context 'with a Mission having a truthy :cash_register_close_out_required' do
      it 'migrates it to a true boolean' do
        mission = create(:mission, cash_register_close_out_required: true)
        down.migrate
        expect(mission.reload.cash_register_proficiency_requirement).to eq 2
      end
    end
  end
end
