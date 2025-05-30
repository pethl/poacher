module LocationsHelper
  def grade_color(grade)
    case grade&.downcase
    when 'grated'         then 'bg-green-300'
    when 'poacher'         then 'bg-emerald-500'
    when 'vintage'         then 'bg-sky-500'
    when 'p50'             then 'bg-amber-500'
    when 'red'             then 'bg-orange-500'
    when 'knuckle duster'  then 'bg-rose-500'
    when 'double barrel'   then 'bg-red-600'
    else 'bg-gray-300' # ungraded or unknown
    end
  end

  def all_grades
    [
      'Grated',
      'Poacher',
      'Vintage',
      'P50',
      'Red',
      'Knuckle Duster',
      'Double Barrel'
    ]
  end
end
