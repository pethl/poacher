import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { Controller } from "stimulus"

import Chart from "chart.js/auto"
import ChartDataLabels from "chartjs-plugin-datalabels"
import Chartkick from "chartkick"

Chart.register(ChartDataLabels)
Chartkick.use(Chart)

import Highcharts from "highcharts" // ✅ Still ok to import for other uses, just not used by Chartkick

// Start Stimulus
const application = Application.start()
window.Stimulus = application // For debugging in console

// Register controllers
import SignatureController from "./controllers/signature_controller"
import TotalController from "./controllers/total_controller"
import HamburgerController from "./controllers/hamburger_controller"
import HighchartsController from "./controllers/highcharts_controller"
import AccordionController from "./controllers/accordion_controller"
import SearchController from "./controllers/search_controller"
import ClickToVisitController from "./controllers/click_to_visit_controller"
import ScoreSliderController from "./controllers/score_slider_controller"

application.register("signature", SignatureController)
application.register("total", TotalController)
application.register("hamburger", HamburgerController)
application.register("highcharts", HighchartsController)
application.register("accordion", AccordionController)
application.register("search", SearchController)
application.register("click-to-visit", ClickToVisitController)
application.register("score-slider", ScoreSliderController)

document.addEventListener("turbo:load", () => {
  console.log(
    "Turbo page load detected - Stimulus controllers should be initialized"
  )
})

console.log("✅ Stimulus initialized")
console.log("✅ Registered controllers:", application.controllers)
