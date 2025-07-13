class MakesheetPdfGenerator
  require 'prawn'
  include ActionView::Helpers::TextHelper
  include MakesheetPdfPage1
  include MakesheetPdfPage2

  def initialize(makesheet)
    @makesheet = makesheet
    @raleway_font_path = 'app/assets/fonts/raleway/Raleway-Medium.ttf'
    @raleway_bold_font_path = 'app/assets/fonts/raleway/Raleway-Bold.ttf'
    @logo_img_path = 'app/assets/images/poacher_logo.jpeg'
  end

  def format_titration(value)
    value ? sprintf('%.3f', value) : ""
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
    draw_page_2(pdf, @makesheet)
  
    pdf.render
  end
  
end