# frozen_string_literal: true

# == Schema Information
#
# Table name: addresses
#
#  id            :bigint(8)        not null, primary key
#  postal_code   :string
#  city          :string           not null
#  street_name_1 :string
#  street_name_2 :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  productor_id  :bigint(8)
#  member_id     :bigint(8)
#  coordinates   :float            is an Array
#

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "une address requiert la présence du champs city valide" do
    new_address = Address.new(
      postal_code: 60_500,
      street_name_1: "1 rue delamorkitu",
      street_name_2: "bâtiment Z"
    )
    assert_not new_address.save
  end

  test "une address DOIT la présence du champs postal_code valide" do
    new_address = Address.new(
      city: "Utopie",
      street_name_1: "1 rue delamorkitu",
      street_name_2: "bâtiment Z"
    )
    assert_not new_address.save
  end

  test "une address DOIT la présence du champs street_name_1 valide" do
    new_address = Address.new(
      postal_code: 60_500,
      street_name_1: "1 rue delamorkitu",
      street_name_2: "bâtiment Z"
    )
    assert_not new_address.save
  end
end
