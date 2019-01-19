# frozen_string_literal: true

require 'test_helper'

class DbAssociationsTest < ActionDispatch::IntegrationTest
  # Associations sur les members
  test "un member peut se voir associer une address" do
    new_member = members(:one)
    new_member.address = addresses(:valid_address)
    assert new_member.address
  end

  test "un member peut se voir associer des missions" do
    new_member = members(:one)
    new_member.missions << missions(:one)
    assert new_member.missions
  end

  test "un admin peut se voir associer des producteurs à gérer" do
    new_member = members(:one)
    new_member.role = 'admin'
    new_member.managed_productors << productors(:one)
    new_member.managed_productors << productors(:two)
    assert new_member.managed_productors
  end

  # Associations sur les productors
  test "un productor peut se voir associer une address" do
    new_productor = productors(:one)
    new_productor.address = addresses(:valid_address)
    assert new_productor.address
  end

  test "un productor peut se voir associer des missions" do
    new_productor = productors(:one)
    new_productor.missions << missions(:one)
    assert new_productor.missions
  end

  test "Un productor peut être géré par plusieurs admins" do
    new_productor = productors(:one)
    admin1 = members(:one)
    admin2 = members(:two)
    new_productor.managers << admin1
    new_productor.managers << admin2
    assert new_productor.managers
  end

  # Associations sur les missions
  test "une mission peut se voir associer des addresses" do
    new_mission = missions(:one)
    new_mission.addresses << addresses(:valid_address)
    assert new_mission.addresses
  end

  test "une mission peut se voir associer des members" do
    new_mission = missions(:one)
    new_mission.members << members(:one)
    assert new_mission.members
  end

  test "une mission peut se voir associer des productors" do
    new_mission = missions(:one)
    new_mission.productors << productors(:one)
    assert new_mission.productors
  end

  test "Une mission peut se faire associer un author" do
    new_mission = missions(:one)
    new_mission.author = members(:one)
    assert new_mission.author
  end

  # Associations sur les addresses
  test "une address peut se voir associer juste à un member" do
    new_address = addresses(:valid_address)
    new_address.member = members(:one)
    assert new_address.member
  end

  test "une address peut se voir associer juste à un productor" do
    new_address = addresses(:valid_address)
    new_address.productor = productors(:one)
    assert new_address.productor
  end

  test "une address peut se voir associer à des missions" do
    new_address = addresses(:valid_address)
    new_address.missions << missions(:one)
    assert new_address.missions
  end

  # Associations sur les Infos
  test "une info peut se voir associer un author" do
    new_info = infos(:one)
    new_info.author = members(:one)
    assert new_info.author
  end
end
