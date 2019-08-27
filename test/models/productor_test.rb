# frozen_string_literal: true

# == Schema Information
#
# Table name: productors
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  description  :text
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  website_url  :string
#  local        :boolean          default(FALSE)
#

require 'test_helper'

class ProductorTest < ActiveSupport::TestCase
  test "un productor requiert la présence du champs name" do
    new_productor = Productor.new(
      description: "blablabla"
    )
    assert_not new_productor.save
  end

  test "un productor est valide si elle contient le name et le description" do
    new_productor = Productor.new(
      name: "titre",
      description: "blablabla"
    )
    assert new_productor.save
  end
end
