# == Schema Information
#
# Table name: documents_categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Documents::Category, type: :model do
  it { is_expected.to have_many :documents }
  it { is_expected.to validate_presence_of :name }
end
