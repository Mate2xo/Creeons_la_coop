require 'rails_helper'

RSpec.describe Documents::Category, type: :model do
  it { is_expected.to have_many :documents }
  it { is_expected.to validate_presence_of :name }
end
