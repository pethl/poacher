class PagesController < ApplicationController
  def home
  end
  
  def dairy_home
  end

  def store_home
  end
  
  def wash_home
  end
  
  def cutting_home
    @open_picksheets_count = Picksheet.where(status: "Open").count
    @assigned_picksheets_count = Picksheet.where(status: "Assigned").count
    @cutting_picksheets_count = Picksheet.where(status: "Cutting").count
  end

  def office_home
  end
  
  def mgmt_home
      makesheets_data = Makesheet.where.not(status: "Finished")
      .where.not(grade: [nil, ""])
      .group(:grade)
      .group(Arel.sql("EXTRACT(MONTH FROM age(CURRENT_DATE, make_date))::int"))
      .order(:grade, Arel.sql("EXTRACT(MONTH FROM age(CURRENT_DATE, make_date))::int"))
      .count

      # The result is a hash with keys in the form [grade, age_in_months] and count as values.
      # We then regroup the data by grade and sort by the age.
      @charts_data = makesheets_data.group_by { |(grade, _age), _count| grade }.transform_values do |group|
        group.map { |(_grade, age), count| [age.to_i, count] }.sort_by { |age, _count| age }
      end
  end
  
  def search
    make_date= params[:make_date]
    puts make_date
    make_date =  DateTime.parse make_date
    @makesheet = Makesheet.where(make_date: make_date).first.id
   
    #redirect_to print_makesheet_pdf_path(:id => @makesheet)
     redirect_to print_makesheet_pdf_path(:id => @makesheet)
     return
  end

  def goodbye
  
  end

end
