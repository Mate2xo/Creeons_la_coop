require 'test_helper'

class ProductorTest < ActiveSupport::TestCase
  test "un productor requiert la présence du champs name" do
    new_productor = Productor.new(
      description: "blablabla"
    )
    assert_not new_productor.save
  end

  test "un productor requiert la présence du champs description" do
    new_productor = Productor.new(
      name: "titre"
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
