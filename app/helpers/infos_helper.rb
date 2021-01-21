# frozen_string_literal: true

module InfosHelper # rubocop:disable Style/Documentation
  def infos_of_this_category(infos, category)
    infos.select { |info| info.category == category }
  end
end
