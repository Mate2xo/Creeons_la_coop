# frozen_string_literal: true

ActiveAdmin.register Group do
  permit_params :name, manager_ids: []

  index do
    selectable_column
    column :name
    column(Group.human_attribute_name(:managers)) do |group|
      manager_links = group.managers.map { |manager| auto_link manager }
      safe_join manager_links, ', '
    end
    column(Group.human_attribute_name(:members_count)) { |group| group.members.size }
    actions
  end

  show do
    attributes_table_for resource do
      default_attribute_table_rows.each do |field|
        row field
      end
      table_for group.members do
        column Member.model_name.human do |member|
          link_to "#{member.last_name} #{member.first_name}", [:admin, member]
        end
      end
      table_for group.managers do
        column  resource.class.human_attribute_name(:managers) do |manager|
          link_to "#{manager.last_name} #{manager.first_name}", [:admin, manager]
        end
      end
    end
  end

  form do |f|
    f.inputs
    f.input :managers, as: :check_boxes, collection: group.members
    actions
  end
end
