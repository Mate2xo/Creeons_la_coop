# frozen_string_literal: true

class MembersMission < ApplicationRecord
  belongs_to :member
  belongs_to :mission
end
