module MakesheetPdfPage2


  def draw_page_2(pdf, makesheet)
    pdf.font 'raleway'

    pdf.table(
      [[
        { content: "Date: <b>#{makesheet.make_date&.strftime('%b %d, %Y')}</b>", inline_format: true },
        { content: "<b>LINCOLNSHIRE POACHER - MAKE SHEET</b>", inline_format: true }
      ]],
      width: pdf.bounds.width,
      cell_style: {
        borders: [],
        padding: [0, 0, 2, 0],
        inline_format: true,
        size: 10
      }
    ) do
      columns(0).align = :left
      columns(1).align = :right
    end

    pdf.move_down 10

    # Define layout sizes
    left_column_width = pdf.bounds.width * (2.0 / 3.0)
    right_column_width = pdf.bounds.width * (1.0 / 3.0)
    start_y = pdf.cursor

    # Left column (2/3 width)
    
    pdf.bounding_box([pdf.bounds.left, start_y], width: left_column_width) do

    pdf.formatted_text([
      { text: "ACIDITY PROFILE", size: 12, styles: [:underline, :bold] }
    ])
    pdf.move_down 2
      long_text = "CRITICAL CONTROL POINT - New 27th Sept 2022 \n" \
                  "Lincolnshire Poacher - NOT MORE THAN 7HRS AT NOT LESS THAN 0.57 TITRATABLE ACIDITY, rennet to mill\n" \
                  "Lincolnshire RED - NOT MORE THAN 7HRS AT NOT LESS THAN 0.57 TITRATABLE ACTIVITY, rennet to mill\n" \
                  "P50 - NOT MORE THAN 7HRS 15MINS AT NOT LESS THAN 0.57 TITRATABLE ACTIVITY, rennet to mill\n" \
                  
      pdf.text_box long_text,
        at: [pdf.bounds.left, pdf.cursor],
        width: left_column_width,
        height: 100, # Adjust based on content
        size:10,
        leading: 2,
        overflow: :truncate,
        inline_format: true

        pdf.move_down 40
        #------------------------------------------------------------
        chart_image_path = generate_chart_image(@chart_data)

        if chart_image_path.present?
          pdf.move_down 20
          pdf.image chart_image_path, width: 450, position: :center
          pdf.move_down 10
        else
          # Draw a placeholder box
          pdf.move_down 20
          pdf.bounding_box([pdf.bounds.left, pdf.cursor], width: 492, height: 230) do
            pdf.stroke_bounds
            pdf.fill_color "999999"
            pdf.text_box "No chart data available", align: :center, valign: :center, size: 12
            pdf.fill_color "000000"
          end
          pdf.move_down 10
        end
        #------------------------------------------------------------

      #slow cheese steps
         # Step 1: Static header rows
         yes_cell, no_cell = yes_no_cell(makesheet.slow_cheese)
          data = [
            [{ content: "IS THIS CHEESE MADE SLOW AS DEFINED BY CRITICAL CONTROL POINT DEFINITION ABOVE?", colspan: 4, align: :center }],
            

            [
              yes_cell,
              { content: "IF YES, FOLLOW WI 01A SLOW CHEESE PROCEDURE - SEE GUIDANCE BELOW", colspan: 2 },
              no_cell
            ],
            [
              { content: "RECORD OF ACTION TAKEN - PLEASE COMPLETE", colspan: 2 },
              { content: "COMPLETED?", colspan: 2 }
            ]
          ]

          # Step 2: Dynamic rows based on boolean fields
          step_data = [
            ["1", "At milling, take x3 salted curd sample - identify with date and as SLOW on sample", *yes_no_cell(makesheet.step_1_curd_sample)],
            ["2", "Record the batch as slow in 'Comments and Corrective Actions' - see below", *yes_no_cell(makesheet.step_2_record_as_slow)],
            ["3", "If known, record the reason for the slow cheese in 'Comments and Corrective Actions'", *yes_no_cell(makesheet.step_3_record_reason)],
            ["4", "Notify Tim cheese is slow - email tim@lincolnshirepoachercheese.com", *yes_no_cell(makesheet.step_4_notify_tim)],
            ["5", "Identify the batch as slow - apply 'HOLD SLOW CHEESE' label with the DATE completed", *yes_no_cell(makesheet.step_5_apply_label)],
            ["6", "Head Cheesemake to record the cheese is slow in the annual cheese make record (RED BOOK)", *yes_no_cell(makesheet.step_6_record_red_book)]
          ]

          # Combine
          data.concat(step_data)

          # Step 3: Draw the table
          pdf.table(data, width: pdf.bounds.width - 20) do
            self.cell_style = { size: 8, inline_format: true }

            row(0).font_style = :bold
            row(0).background_color = 'D3D3D3'
            #row(1)..columns(1).background_color = "D3D3D3"
            row(2).background_color = 'F9F9F9'
            row(2).columns(0..1).background_color = "D3D3D3"

            rows(0..2).align = :center

            (3..8).each do |i|
              row(i).columns(0).align = :center
              row(i).columns(1).align = :left
              row(i).columns(2).align = :center
              row(i).columns(3).align = :center
            end
          end

    end



    # Right column (1/3 width)
    pdf.bounding_box(
      [pdf.bounds.left + left_column_width, start_y],
      width: right_column_width,
      height: 480 # adjust as needed
    ) do
      pdf.stroke_bounds
      pdf.move_down 4

      # Print "NOTES" centered, bold — no underline
      pdf.formatted_text_box(
        [{ text: "NOTES", size: 12, styles: [:bold] }],
        at: [pdf.bounds.left, pdf.cursor],
        width: pdf.bounds.width,
        align: :center
      )

      pdf.move_down 16  

      # Draw a line across the full bounding box width
      pdf.stroke_horizontal_rule
      pdf.move_down 10 

      pdf.text "RECORD OF ENGINEERING OR MAINTENACE WORK COMPLETED", size: 8, align: :center

      pdf.move_down 120
      pdf.stroke_horizontal_rule
      pdf.move_down 20

      side_margin = 10
      box_width = pdf.bounds.width - (side_margin * 2)

      pdf.bounding_box(
        [pdf.bounds.left + side_margin, pdf.cursor],
        width: box_width,
        height: 120
      ) do
        pdf.text_box(
          makesheet.post_make_notes.to_s,
          at: [pdf.bounds.left, pdf.cursor],
          width: box_width,
          height: 120,
          size: 10,
          leading: 2,
          overflow: :truncate,
          inline_format: false
        )
      end
         end
         
         pdf.text "Page: 2\n Ref: CD01", size: 8, align: :right
  end

  # ✅ Helper method for formatting YES/NO
  def yes_no_cell(value)
    highlight_bg = '444444'  # Dark gray (not quite black)
    text_gray    = '888888'  # Subdued gray
    white_text   = 'FFFFFF'
  
    case value
    when true
      [
        {
          content: "YES",
          inline_format: true,
          background_color: highlight_bg,
          text_color: white_text,
          align: :center
        },
        {
          content: "NO",
          inline_format: true,
          text_color: text_gray,
          align: :center
        }
      ]
    when false
      [
        {
          content: "YES",
          inline_format: true,
          text_color: text_gray,
          align: :center
        },
        {
          content: "NO",
          inline_format: true,
          background_color: highlight_bg,
          text_color: white_text,
          align: :center
        }
      ]
    else
      [
        { content: "YES", inline_format: true, align: :center },
        { content: "NO", inline_format: true, align: :center }
      ]
    end
  end


  def generate_chart_image(chart_data)
    base_url = "https://image-charts.com/chart"
    x = chart_data.map(&:first).join(",")
    y = chart_data.map(&:last).join(",")
  
    url = "#{base_url}?cht=lc&chs=600x300&chd=t:#{y}&chxt=x,y&chxl=0:|#{x}&chtt=Acidity+Profile"
  
    file_path = Rails.root.join("tmp", "chart_#{SecureRandom.hex(4)}.png")
    File.open(file_path, 'wb') do |f|
      f.write URI.open(url).read
    end
    file_path.to_s
  end
  
end
