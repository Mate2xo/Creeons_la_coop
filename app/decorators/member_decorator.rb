# frozen_string_literal: true

# MemberDecorator
class MemberDecorator < Draper::Decorator
  decorates_association :static_slots
  delegate_all

  def hours_worked_in_the_last_three_months(csv: false)
    hours_per_month = 3.times.with_object([]) do |n, array|
      array[n] = "#{I18n.localize(Date.current - n.month, format: :only_month)} :
                                  #{model.monthly_worked_hours(Date.current - n.month)}"
    end
    if csv
      hours_per_month.reverse.join("\n")
    else
      h.safe_join(hours_per_month.map { |month_total| h.content_tag(:p, month_total) }.reverse)
    end
  end
end
