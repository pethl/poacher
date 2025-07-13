class MakesheetPdfGenerator
  require 'open-uri'
  require 'prawn'
  include ActionView::Helpers::TextHelper
  include MakesheetPdfPage1
  include MakesheetPdfPage2

  def initialize(makesheet, chart_data = nil)
    @makesheet = makesheet
    @chart_data = chart_data
  
    @raleway_font_path = 'app/assets/fonts/raleway/Raleway-Medium.ttf'
    @raleway_bold_font_path = 'app/assets/fonts/raleway/Raleway-Bold.ttf'
    @logo_img_path = 'app/assets/images/poacher_logo.jpeg'
  end

  def format_titration(value)
    value ? sprintf('%.3f', value) : ""
  end

  def generate_chart_image(chart_data)
    return nil if chart_data.blank?
  
    base_url = "https://image-charts.com/chart"
    x_labels = chart_data.map(&:first)
    y_values = chart_data.map(&:last)
  
    # Convert values to comma-separated string
    y_series = y_values.join(",")
    x_axis_labels = x_labels.each_with_index.map { |label, i| "#{i}:|#{label}" }.join("|")
  
    url = "#{base_url}?" +
          "cht=lc" +                          # line chart
          "&chs=600x300" +                    # size
          "&chd=t:#{y_series}" +              # data
          "&chxt=x,y" +                       # show x & y axis
          "&chxl=0:|#{x_labels.join('|')}" +  # x-axis labels
          "&chtt=Acidity+Profile"            # chart title
  
    # Save to temp file
    tmp_file = Rails.root.join("tmp", "acidity_chart_#{SecureRandom.hex(4)}.png")
    File.open(tmp_file, 'wb') do |file|
      file.write URI.open(url).read
    end
  
    tmp_file.to_s
  end

  def generate
    pdf = Prawn::Document.new(page_size: "A4", page_layout: :landscape)

    pdf.font_families.update(
      'raleway' => {
        normal: @raleway_font_path,
        bold: @raleway_bold_font_path
      }
    )

    draw_page_1(pdf, @makesheet) # this is your new method

    pdf.start_new_page

   # pdf.rotate(180, origin: [pdf.bounds.width / 2, pdf.bounds.height / 2]) do
   #   pdf.bounding_box([0, pdf.bounds.top], width: pdf.bounds.width, height: pdf.bounds.height) do
        draw_page_2(pdf, @makesheet)
    #  end
    #end
  
    pdf.render
  end
  
end