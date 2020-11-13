# frozen_string_literal: true

# MemberDecorator
class MemberDecorator < Draper::Decorator
  delegate_all

  def hours_worked_in_the_three_last_months(csv: false)
    hours_per_month = []
    if csv == false
      3.times do |n|
        hours_per_month[n] = h.content_tag(:p, "#{I18n.localize(Date.current - n.month, format: :only_month)} :
                                              #{model.monthly_worked_hours(Date.current - n.month)}")
      end
      h.safe_join hours_per_month.reverse
    else
      3.times do |n|
        hours_per_month[n] = "#{I18n.localize(Date.current - n.month, format: :only_month)} :
                            #{model.monthly_worked_hours(Date.current - n.month)}"
      end
      hours_per_month.reverse.join("\n")

    end
  end
end
