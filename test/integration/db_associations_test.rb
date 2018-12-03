require 'test_helper'

class DbAssociationsTest < ActionDispatch::IntegrationTest
  # Associations sur les members
  test "un membre peut se voir associer une address" do
    new_member = members(:one)
    new_member.address = addresses(:valid_address)
    assert new_member.address
  end

  test "un membre peut se voir associer des missions" do
    new_member = members(:one)
    new_member.missions = missions(:one)
    assert new_member.missions
  end

  # Associations sur les productors
  test "un productor peut se voir associer une address" do
    new_productor = productors(:one)
    new_productor.address = addresses(:valid_address)
    assert new_productor.address
  end

  test "un productor peut se voir associer des missions" do
    new_productor = productors(:one)
    new_productor.missions = missions(:one)
    assert new_productor.missions
  end

  # Associations sur les missions
  test "un mission peut se voir associer des addresses" do
    new_mission = missions(:one)
    new_mission.addresses << addresses(:valid_address)
    assert new_mission.addresses
  end

  test "un mission peut se voir associer des missions" do
    new_mission = missions(:one)
    new_mission.missions = missions(:one)
    assert new_mission.missions
  end

end
