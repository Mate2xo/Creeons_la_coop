# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id          :bigint(8)        not null, primary key
#  name        :string           not null
#  description :text             not null
#  due_date    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :bigint(8)
#

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

  test "une mission est valide si elle contient, l'author, le name et le description" do
    new_mission = Mission.new(
      name: "titre",
      description: "blablabla",
      author: members(:one)
    )
    assert new_mission.save
  end
end
