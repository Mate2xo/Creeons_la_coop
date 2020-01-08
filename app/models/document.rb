# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Document < ApplicationRecord
  has_one_attached :file
end
