Time::DATE_FORMATS[:humanized_ago]  = ->(time) do
  st = Time.now.beginning_of_day
  nd = Time.now.end_of_day

  case
  when time.between?(st + 1.day, nd + 1.day)
    "Morgen, #{time.strftime('%H:%M')}"
  when time.between?(st, nd)
    "Heute, #{time.strftime('%H:%M')}"
  when time.between?(st - 1.day, nd - 1.day)
    "Gestern, #{time.strftime('%H:%M')}"
  when time.between?(st - 6.day, nd - 2.day)
    I18n.l(time, format: :day_of_week_with_time)
  else
    I18n.l(time, format: :abbr_day)
  end
end
