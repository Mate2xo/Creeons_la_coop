# frozen_string_literal: true

ActiveAdmin.register Group do
  menu if: proc { authorized? :index, Group }
  permit_params :name, roles: [], manager_ids: []
  includes :managers

  index do
    selectable_column
    column :name
    column(Group.human_attribute_name(:managers)) do |group|
      manager_links = group.managers.map { |manager| auto_link manager }
      safe_join manager_links, ', '
    end
    column(Group.human_attribute_name(:members_count)) { |group| group.members.size }
    column(:roles) { |group| group.roles.texts.join(', ') }
    actions
  end

  filter :name
  filter :roles, as: :select, collection: Group.roles.options
  filter :managers
  filter :members
  filter :created_at
  filter :updated_at

  show do
    attributes_table_for resource do
      row :name
      row(:roles) { resource.roles.texts.join(', ') }
      row :created_at
      row :updated_at
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
    f.inputs do
      f.input :name
      f.input :roles, as: :check_boxes, collection: Group.roles.options
      f.input :managers, as: :check_boxes, collection: group.members
    end
    actions
  end
end
