# frozen_string_literal: true

module Members
  # extracts a member's static slot selection, assigns the selected static slots, and updates the member
  class UpdateTransaction
    include Dry::Transaction

    tee :params
    tee :extract_static_slots_ids
    step :assign_static_slot
    step :save_in_history
    tee :enroll_member_according_to_new_static_slots_or_send_error_report
    step :update_member

    private

    def params(input)
      @current_member = input[:current_member]
      @static_slots_attributes = input[:permitted_params][:static_slots_attributes]
      input[:permitted_params].delete('static_slots_attributes')
      @member_params = input[:permitted_params]
    end

    def extract_static_slots_ids(input)
      return Success(input) if @static_slots_attributes.nil?

      @static_slot_ids = []
      @static_slots_attributes.each_pair do |_key, value|
        @static_slot_ids << value['id']
      end
      @static_slot_ids.uniq
      Success(input)
    end

    def assign_static_slot(input)
      return Success(input) if @static_slots_attributes.nil?

      @static_slot_ids.each do |static_slot_id|
        unless ::MemberStaticSlot.create(member_id: @current_member.id, static_slot_id: static_slot_id)
          Failure(error: t('activerecord.errors.models.static_slot.messages.static_slot_attribution_failure'))
        end
      end
      Success(input)
    end

    def save_in_history(input)
      return Success(input) if @static_slots_attributes.nil?

      @static_slot_ids.each do |static_slot_id|
        unless ::HistoryOfStaticSlotSelection.create(member_id: @current_member.id, static_slot_id: static_slot_id)
          Failure(error: t('activerecord.errors.models.static_slot.messages.selection_save_failure'))
        end
      end
      Success(input)
    end

    def enroll_member_according_to_new_static_slots_or_send_error_report(input)
      return Success(input) if @static_slots_attributes.nil?

      static_members_recruiter = StaticMembersRecruiter.new
      static_members_recruiter.enrollment_for_one_member(@current_member)

      input[:reports] = static_members_recruiter.reports.join(', ') if static_members_recruiter.reports.any?
      Success(input)
    end

    def update_member(input)
      Failure(t('activerecord.errors.messages.update_fail')) unless @current_member.update(@member_params)

      Success(input)
    end
  end
end
