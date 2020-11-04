class MemberDecorator < Draper::Decorator
  delegate_all

  def worked_hours_of_three_last_months
    hours_per_month = []
    3.times do |n|
      hours_per_month[n] = h.content_tag(:p, "#{I18n.localize(Date.current - n.month, format: :only_month)} :
                                              #{model.monthly_worked_hours(Date.current - n.month)}")
    end
    h.safe_join hours_per_month.reverse
  end

  def worked_hours_of_three_last_months_csv_version
    hours_per_month = []
    3.times do |n|
      hours_per_month[n] = "#{I18n.localize(Date.current - n.month, format: :only_month)} :
                            #{model.monthly_worked_hours(Date.current - n.month)}"
    end
    hours_per_month.reverse.join("\n")
  end
end
