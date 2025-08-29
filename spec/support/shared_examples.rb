# frozen_string_literal: true

RSpec.shared_examples 'a view without missing translations' do
  context 'with the :fr locale' do
    it 'has no missing keys' do
      I18n.with_locale(:fr) { expect { render }.not_to raise_error }
    end
  end
end

RSpec.shared_examples 'a model without missing validation error translations' do |_parameter|
  it 'has no missing keys' do
    resource.valid?

    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        expect(resource.errors.full_messages).not_to include(/translation missing/i)
      end
    end
  end
end
