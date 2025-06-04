# app/services/makesheet_radial_svg.rb
class MakesheetRadialSvg
  require 'builder'

  def self.generate(makesheet)
    svg = Builder::XmlMarkup.new(indent: 2)
    size = 400
    center = size / 2

    cheeses = makesheet.number_of_cheeses.to_i
    weight = makesheet.total_weight.to_f
    date = makesheet.make_date.to_s

    svg.instruct!
    svg.svg(xmlns: "http://www.w3.org/2000/svg", width: size, height: size, style: 'font-family: Raleway, sans-serif;') do
      svg.rect(x: 0, y: 0, width: size, height: size, fill: 'white')

      # White center only, for debugging text
      svg.circle(cx: center, cy: center, r: 100, fill: 'white', stroke: 'black', 'stroke-width': 1)

      # Debug bounding box (optional)
      # svg.rect(x: 100, y: 100, width: 200, height: 200, fill: 'none', stroke: 'red')

      svg.text_(x: center, y: center - 20,
        'text-anchor': 'middle', 'font-size': 20,
        fill: 'red') { svg.text! "HELLO" }

      # svg.text_(x: center, y: center + 5,
#   'text-anchor': 'middle', 'font-size': 20,
#   'font-family': 'Raleway, sans-serif', fill: 'black', stroke: 'none') { svg.text! "#{weight.round}kg" }kg" }

      # svg.text_(x: center, y: center + 30,
#   'text-anchor': 'middle', 'font-size': 20,
#   'font-family': 'Raleway, sans-serif', fill: 'black', stroke: 'none') { svg.text! cheeses.to_s }
    end

    svg.target!
  end
end