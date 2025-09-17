# frozen_string_literal: true

# == Schema Information
#
# Table name: documents_sub_categories
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#
# Indexes
#
#  index_documents_sub_categories_on_category_id           (category_id)
#  index_documents_sub_categories_on_name_and_category_id  (name,category_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => documents_categories.id)
#
require 'rails_helper'

RSpec.describe Documents::SubCategory do
  subject(:sub_category) { build(:documents_sub_category) }

  it { is_expected.to have_many :documents }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:category_id) }
end
