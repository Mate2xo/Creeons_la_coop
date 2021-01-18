# frozen_string_literal: true

require 'rails_helper'
require 'rake'
Rake.application.rake_require 'tasks/remove_old_infos'

RSpec.describe 'info:remove_old_infos', type: :feature do
  it 'removes the infos whose the last update dateback to more than one month' do
    create :info, updated_at: DateTime.current - 2.months

    Rake::Task['info:remove_old_infos'].execute

    expect(Info.count).to eq 0
  end

  it "doesn't remove infos whose the last update dateback to less than one month" do
    create :info, updated_at: DateTime.current - 2.weeks

    Rake::Task['info:remove_old_infos'].execute

    expect(Info.count).to eq 1
  end
end
