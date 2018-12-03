require 'test_helper'

class MissionTest < ActiveSupport::TestCase
  test "une mission requiert la présence du champs name" do
    new_mission = Mission.new(
      description: "blablabla"
    )
    assert_not new_mission.save
  end

  test "une mission requiert la présence du champs description" do
    new_mission = Mission.new(
      name: "titre"
    )
    assert_not new_mission.save
  end

  test "une mission est valide si elle contient le name et le description" do
    new_mission = Mission.new(
      name: "titre",
      description: "blablabla"
    )
    assert new_mission.save
  end 
end
