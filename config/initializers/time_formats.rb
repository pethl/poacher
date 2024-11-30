Date::DATE_FORMATS[:default] = "%m/%d/%Y"
Date::DATE_FORMATS[:month_and_year] = '%B %Y'
Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }
Time::DATE_FORMATS[:time_24] = lambda { |time| time.strftime("%H:%M ") }
Time::DATE_FORMATS[:global_date_time] = '%Y-%m-%d %H:%M'
Date::DATE_FORMATS[:uk] = '%d %b %Y'
Time::DATE_FORMATS[:uk_time] = '%d %b %Y'
Time::DATE_FORMATS[:uk_clean_date] = '%d-%m-%y'
Time::DATE_FORMATS[:uk_day] = '%a %d %b %Y'
Time::DATE_FORMATS[:uk_m_y] = '%b %Y'
Date::DATE_FORMATS[:usa_dt] = '%b %d, %Y %H:%M'
Time::DATE_FORMATS[:hour_clock_12] = '%I:%M %p'
Date::DATE_FORMATS[:custom] = "%Y-%m-%d"
Date::DATE_FORMATS[:long_day] = "%A"

#%A Monday
#%a Mon