# Date Formats
Date::DATE_FORMATS[:default] = "%m/%d/%Y"  # Month/Day/Year (e.g., "03/05/2025")
Date::DATE_FORMATS[:month_and_year] = '%B %Y'  # Full month name and year (e.g., "March 2025")
Date::DATE_FORMATS[:uk] = '%d %b %Y'  # Day ShortMonth Year (e.g., "05 Mar 2025")
Date::DATE_FORMATS[:uk_clean_date] = '%d-%m-%y'  # Day-Month-Year (2-digit) (e.g., "05-03-25")
Date::DATE_FORMATS[:custom] = "%Y-%m-%d"  # Year-Month-Day (ISO 8601) (e.g., "2025-03-05")
Date::DATE_FORMATS[:long_day] = "%A"  # Full weekday name (e.g., "Wednesday")
Date::DATE_FORMATS[:short_day] = "%a"  # Short weekday name (e.g., "Wed")
Date::DATE_FORMATS[:uk_day] = '%A %d %b %Y'  # FullWeekday Day ShortMonth Year (e.g., "Wednesday 05 Mar 2025")

# Time Formats
Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }  # Full month with ordinal day (e.g., "March 5th")
Time::DATE_FORMATS[:time_24] = lambda { |time| time.strftime("%H:%M") }  # 24-hour time (e.g., "08:30")
Time::DATE_FORMATS[:global_date_time] = '%Y-%m-%d %H:%M'  # ISO datetime (e.g., "2025-03-05 00:00")
Time::DATE_FORMATS[:uk] = '%d %b %Y'  # Same as Date::DATE_FORMATS[:uk] - DUPLICATE (e.g., "05 Mar 2025")
Time::DATE_FORMATS[:uk_clean_date] = '%d-%m-%y'  # Same as Date::DATE_FORMATS[:d_uk_clean_date] - DUPLICATE (e.g., "05-03-25")
Time::DATE_FORMATS[:uk_day] = '%a %d %b %Y'  # ShortWeekday Day ShortMonth Year (e.g., "Wed 05 Mar 2025")
Time::DATE_FORMATS[:uk_day_time] = '%a %d %b %Y, %H:%M'  # ShortWeekday Day ShortMonth Year, Time (e.g., "Wed 05 Mar 2025, 00:00")
Time::DATE_FORMATS[:uk_m_y] = '%b %Y'  # ShortMonth Year (e.g., "Mar 2025")
Time::DATE_FORMATS[:hour_clock_12] = '%I:%M %p'  # 12-hour clock with AM/PM (e.g., "12:00 AM")
Time::DATE_FORMATS[:day_short_date] = '%a %d/%m'  # ShortWeekday Day/Month (e.g., "Wed 05/03")

# Notes:
# - Found duplicates:
#   1. Date::DATE_FORMATS[:uk] and Time::DATE_FORMATS[:uk_time] are identical
#   2. Date::DATE_FORMATS[:d_uk_clean_date] and Time::DATE_FORMATS[:uk_clean_date] are identical
# - Consider consolidating these duplicate formats
# - Common format reference:
#   %A - Full weekday (Monday)
#   %a - Short weekday (Mon)
#   %B - Full month (March)
#   %b - Short month (Mar)
#   %d - Day of month (zero-padded)
#   %m - Month number (zero-padded)
#   %Y - Year (4-digit)
#   %y - Year (2-digit)
#   %H - Hour (24-hour)
#   %I - Hour (12-hour)
#   %M - Minute
#   %p - AM/PM