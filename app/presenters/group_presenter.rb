class GroupPresenter
  def initialize(group)
    @group = group
  end

  def convert_name
    @group.name.split.join('_')
  end

  def manager
    return '' if @group.manager.nil?
    return "#{I18n.t('activerecord.attributes.group.manager')}: #{@group.manager.first_name} #{@group.manager.last_name}" unless @group.manager.nil?
  end

  def manager_id
    return 0 if @group.manager.nil?
    return @group.manager.id unless @group.manager.nil?
  end
end
