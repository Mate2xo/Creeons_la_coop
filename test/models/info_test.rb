# frozen_string_literal: true

require 'test_helper'

class InfoTest < ActiveSupport::TestCase
  test "une info requiert la présence du champs title" do
    new_info = Info.new(
      content: "blablabla"
    )
    assert_not new_info.save
  end

  test "une info requiert la présence du champs content" do
    new_info = Info.new(
      title: "titre"
    )
    assert_not new_info.save
  end

  test "une info est valide si elle contient l'author, le title et le content" do
    new_info = Info.new(
      title: "titre",
      content: "blablabla",
      author: members(:one)
    )
    assert new_info.save
  end
end
