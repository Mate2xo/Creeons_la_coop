# frozen_string_literal: true

ActiveAdmin.register StaticSlot do
  permit_params :week_day, :hour, :minute, :week_type, static_slot_ids: []
  index do
    selectable_column
    column(:week_day) { |resource| StaticSlot.human_enum_name('week_day', resource.week_day) }
    column(:hours) { |resource| "#{resource.hour}h#{resource.minute}" }
    column :week_type
    actions
  end

  show do
    default_main_content
    table_for resource.members do
      column Member.model_name.human do |member|
        link_to "#{member.last_name} #{member.first_name}", [:admin, member]
      end
    end
  end

  form do |f|
    f.inputs :week_day,
             :hour,
             :minute,
             :week_type
    actions
  end
end
