# frozen_string_literal: true

# Helpers for Member-related views
module MembersHelper
  def change_groups_collection_in_to_string(groups)
    names_groups = ''
    groups.each do |group|
      names_groups = names_groups + Member.human_enum_name(:group, group.name) + ', '
    end
    names_groups.delete_suffix(', ')
  end
end
