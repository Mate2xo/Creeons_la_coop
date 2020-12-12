# frozen_string_literal: true

ActiveAdmin.register StaticSlot do
  permit_params :week_day, :start_time, :hour, :minute, :week_type, static_slot_ids: []

  decorate_with StaticSlotDecorator

  index do
    selectable_column
    column(:week_day) { |resource| StaticSlot.human_enum_name('week_day', resource.week_day) }
    column(:start_time) { |resource| resource.start_time.strftime('%Hh%M') }
    column :week_type
    actions
  end

  show do
    attributes_table_for resource do
      row(:week_day) { |resource| StaticSlot.human_enum_name('week_day', resource.week_day) }
      row(:start_time) { resource.start_time.strftime('%Hh%M') }
      row(:week_type)
      row(:created_at)
      row(:updated_at)
    end
    table_for resource.members do
      column Member.model_name.human do |member|
        link_to "#{member.last_name} #{member.first_name}", [:admin, member]
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :week_day
      f.input :hour, as: :select, collection: 0..23
      f.input :minute, as: :select, collection: 0..59
      f.input :week_type
    end
    f.actions
  end

  controller do
    def create
      permitted_params = params.require(:static_slot).permit(:week_day, :week_type, :hour, :minute)
      permitted_params.merge!({ start_time: DateTime.new(2020, 1, 1, permitted_params[:hour].to_i,
                                                    permitted_params[:minute].to_i) })
      @static_slot = StaticSlot.new(permitted_params)
      if @static_slot.save
        redirect_to admin_static_slot_path(@static_slot), notice: 'success'
      else
        flash[:error] = static_slot.erros.full_messages.join(', ')
        render :new
      end
    end

    def update
      @static_slot = StaticSlot.find(permitted_params[:id])
      permitted_params = params.require(:static_slot).permit(:week_day, :week_type, :hour, :minute)
      permitted_params.merge!({ start_time: DateTime.new(2020, 1, 1, permitted_params[:hour].to_i,
                                                    permitted_params[:minute].to_i) })
      if @static_slot.update(permitted_params)
        redirect_to admin_static_slot_path(@static_slot), notice: 'success'
      else
        flash[:error] = static_slot.erros.full_messages.join(', ')
        render :edit
      end
    end
  end
end
