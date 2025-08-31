# frozen_string_literal: true

RSpec.shared_examples 'a view without missing translations' do
  I18n.available_locales.each do |locale|
    it "has no missing keys for the :#{locale} locale" do
      I18n.with_locale(locale) { expect { render }.not_to raise_error }
    end
  end
end

RSpec.shared_examples 'a model without missing validation error translations' do |_parameter|
  I18n.available_locales.each do |locale|
    it "has no missing keys for the #{locale} locale" do
      resource.valid?

      I18n.with_locale(locale) do
        expect(resource.errors.full_messages).not_to include(/translation missing/i)
      end
    end
  end
end
