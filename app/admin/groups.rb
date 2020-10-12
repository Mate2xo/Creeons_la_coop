# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
#
#

ActiveAdmin.register Group do
  permit_params :name, :manager_id

  index do
    selectable_column
    column :name
    column :manager
    column(I18n.t('activerecord.attributes.group.number_of_members')) { |group| group.members.size }
    actions
  end

  show do
    attributes_table_for resource do
      default_attribute_table_rows.each do |field|
        row field
      end
      table_for group.members do
        column 'members' do |member|
          link_to "#{member.last_name} #{member.first_name}", [:admin, member]
        end
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
