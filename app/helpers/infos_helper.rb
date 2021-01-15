# frozen_string_literal: true

module InfosHelper
  def infos_of_this_category(category)
    Info.where(category: category)
  end
end
