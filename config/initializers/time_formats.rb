Date::DATE_FORMATS[:default] = "%m/%d/%Y"
Date::DATE_FORMATS[:month_and_year] = '%B %Y'  
Date::DATE_FORMATS[:uk] = '%d %b %Y' #01 Jan 2025
Date::DATE_FORMATS[:usa_dt] = '%b %d, %Y %H:%M'
Date::DATE_FORMATS[:custom] = "%Y-%m-%d"
Date::DATE_FORMATS[:long_day] = "%A"
Date::DATE_FORMATS[:short_day] = "%a"
Date::DATE_FORMATS[:d_uk_day] = '%A %d %b %Y' # WED 05 Mar 2025
Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") } #March 4th
Time::DATE_FORMATS[:time_24] = lambda { |time| time.strftime("%H:%M ") } # 08:30
Time::DATE_FORMATS[:global_date_time] = '%Y-%m-%d %H:%M' # 2025-03-05 00:00
Time::DATE_FORMATS[:uk_time] = '%d %b %Y' # 05 Mar 2025
Time::DATE_FORMATS[:uk_clean_date] = '%d-%m-%y' # 05-03-25
Time::DATE_FORMATS[:uk_day] = '%a %d %b %Y' # Wed 05 Mar 2025
Time::DATE_FORMATS[:uk_day_time] = '%a %d %b %Y,  %H:%M' # Wed 05 Mar 2025, 00:00
Time::DATE_FORMATS[:uk_m_y] = '%b %Y' # Mar 2025
Time::DATE_FORMATS[:hour_clock_12] = '%I:%M %p' # 12:00 AM
Time::DATE_FORMATS[:day_short_date] = '%a %d/%m' # Wed 4/10

#%A Monday
#%a Mon