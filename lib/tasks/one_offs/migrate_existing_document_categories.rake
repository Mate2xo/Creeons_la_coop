# frozen_string_literal: true

namespace :one_offs do
  # TODO: delete-me, with the related enumerize translations
  desc 'Migrate current Document:category values to Category records'
  task migrate_document_categories_to_records: :environment do
    Document.all.group_by(&:category_before_type_cast).each do |category_name, records|
      category = Documents::Category.create! name: I18n.t("enumerize.document.category.#{category_name}")
      category.documents = records
    end
  end
end
