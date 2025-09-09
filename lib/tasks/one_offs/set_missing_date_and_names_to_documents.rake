# frozen_string_literal: true

namespace :one_offs do
  # TODO: delete-me
  desc 'Old record have no name or date; fill up these attributes from the :name and :created_at, and associate them with categories'
  task set_missing_date_and_names_and_categories_to_documents: :environment do
    Document.where(name: nil).or(Document.where(date: nil))
            .group_by(&:category_before_type_cast).each do |category_name, records|
      category = Documents::Category.create_or_find_by name: I18n.t("enumerize.document.category.#{category_name}")
      records.each do |doc|
        doc.name = doc.file.filename.to_s unless doc.name
        doc.date = doc.created_at unless doc.date
        doc.category = category
        doc.save!
      end
    end
  end
end
