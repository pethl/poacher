// Turbo and Stimulus imports
import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

// Chart.js (auto) and adapters/plugins
import Chart from "chart.js/auto"
import "chartjs-adapter-date-fns"
import ChartDataLabels from "chartjs-plugin-datalabels"

// Register Chart.js plugins immediately after importing Chart.js
Chart.register(ChartDataLabels)

// Chartkick (after Chart.js setup!)
import Chartkick from "chartkick"
Chartkick.use(Chart)

// Optional (Highcharts for separate use-cases)
import Highcharts from "highcharts"

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
import MakesheetController from "./controllers/makesheet_controller"
import MakesheetPickerController from "./controllers/makesheet_picker_controller"
import TraceabilityController from "./controllers/traceability_controller"
import ToggleViewController from "./controllers/toggle_view_controller"
import BatchWeightController from "./controllers/batch_weight_controller"
import QrScannerController from "./controllers/qr_scanner_controller"
import FilterController from "./controllers/filter_controller"
import LocationHighlightController from "./controllers/location_highlight_controller"
import TurningController from "./controllers/turning_controller"
import CheeseWashController from "./controllers/cheese_wash_controller"

import "flowbite"
import "flatpickr/dist/flatpickr.min.css"

application.register("signature", SignatureController)
application.register("total", TotalController)
application.register("hamburger", HamburgerController)
application.register("highcharts", HighchartsController)
application.register("accordion", AccordionController)
application.register("search", SearchController)
application.register("click-to-visit", ClickToVisitController)
application.register("score-slider", ScoreSliderController)
application.register("makesheet", MakesheetController)
application.register("makesheet-picker", MakesheetPickerController)
application.register("traceability", TraceabilityController)
application.register("toggle-view", ToggleViewController)
application.register("batch-weight", BatchWeightController)
application.register("qr-scanner", QrScannerController)
application.register("filter", FilterController)
application.register("location-highlight", LocationHighlightController)
application.register("turning", TurningController)
application.register("cheese-wash", CheeseWashController)

document.addEventListener("turbo:load", () => {
  console.log(
    "Turbo page load detected - Stimulus controllers should be initialized"
  )
})

console.log("✅ Stimulus initialized")
console.log("✅ Registered controllers:", application.controllers)
