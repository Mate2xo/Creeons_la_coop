# frozen_string_literal: true

class Members::UpdateTransaction
  include Dry::Transaction

  tee :extract_ids
  step :assign_static_slot
  step :update_member

  private

  def extract_ids(input)
    return Success(input) if input[:permitted_params][:static_slots_attributes].nil?

    static_slot_ids = []
    input[:permitted_params][:static_slots_attributes].values.each do |value|
      static_slot_ids << value['id']
    end
    input.merge!({ static_slot_ids: static_slot_ids })
    Success(input)
  end

  def assign_static_slot(input)
    return Success(input) if input[:permitted_params][:static_slots_attributes].nil?

    input[:static_slot_ids].each do |static_slot_id|
      unless ::StaticSlotMember.create(member_id: input[:current_member].id, static_slot_id: static_slot_id)
        Failure(error: t('activerecord.errors.models.mission.messages.static_slot_extraction_failure'))
      end
    end
    Success(input)
  end

  def update_member(input)
    input[:permitted_params].delete('static_slots_attributes')
    unless input[:current_member].update(input[:permitted_params])
      Failure(t('activerecord.errors.messages.update_fail'))
    end

    Success(input)
  end
end
