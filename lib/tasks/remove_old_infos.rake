# frozen_string_literal: true

# This namespace contains all tasks related to the infojmodel
namespace :info do # rubocop:disable Metrics/BlockLength
  desc 'removes the infos whose the last update dateback to more than one month'
  task remove_old_infos: :environment do
    Info.where('updated_at < ?', DateTime.current - 1.month).destroy_all
  end
end
