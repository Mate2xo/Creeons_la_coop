# frozen_string_literal: true

class AddMemberRefToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_reference :addresses, :member, foreign_key: true
  end
end
