class GroupPresenter
  def initialize(group)
    @group = group
  end

  def convert_name
    @group.name.split.join('_')
  end

  def members
    Member.joins(:group_members).where('group_members.group_id = ?', @group.id).includes(:address, :avatar_attachment)
  end
end
