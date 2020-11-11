# frozen_string_literal: true

class GroupPresenter
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  def initialize(group)
    @group = group
  end

  def underscored_name
    @group.name.split.join('_')
  end

  def all_manager_links
    manager_links = @group.managers.map do |manager|
      link_to manager.first_name, Rails.application.routes.url_helpers.member_path(manager.id)
    end
    safe_join manager_links, ', '
  end
end
