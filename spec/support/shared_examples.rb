# frozen_string_literal: true

RSpec.shared_examples "a view without missing translations" do
  describe ":en locale" do
    it "has no missing keys" do
      I18n.locale = :en
      expect{ render }.not_to raise_error
    end
  end

  describe ":fr locale" do
    it "has no missing keys" do
      I18n.locale = :fr
      expect{ render }.not_to raise_error
    end
  end
end
