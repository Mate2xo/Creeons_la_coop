require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "une address requiert la présence du champs city valide" do
    new_address = Address.new(
      postal_code: 60500,
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
      postal_code: 60500,
      street_name_1: "1 rue delamorkitu",
      street_name_2: "bâtiment Z"
    )
    assert_not new_address.save
  end 
end
