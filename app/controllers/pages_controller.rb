class PagesController < ApplicationController
  require 'ostruct'

  # Which group a section's "_home" action requires. Nav hides links the user can't see
  # (app/views/layouts/_main_nav.html.erb), but that's UX only — this before_action is the
  # actual enforcement, since hiding a link never stops someone typing the URL directly.
  SECTION_GROUPS = {
    dairy_home: "dairy",
    store_home: "store",
    wash_home: "store",
    cutting_home: "cutting",
    office_home: "office",
    hs_home: "hs",
    mgmt_home: "mgmt",
  }.freeze

  before_action :require_section_access!, only: SECTION_GROUPS.keys

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

  def hs_home
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

  def rennet_guidance
    @rows = Reference
              .where(group: "rennet_usage", active: true)
              .order(:sort_order) # ascending = 1,2,3
  end

  private

  def require_section_access!
    required_group = SECTION_GROUPS.fetch(action_name.to_sym)
    return if current_user.can_access_section?(required_group)

    raise CanCan::AccessDenied.new(
      "You don't have access to that section.", action_name, PagesController
    )
  end

end
