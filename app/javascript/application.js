import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { Controller } from "stimulus"
import Highcharts from "highcharts"
//import { definitionsFromContext } from "stimulus/webpack-helpers"

// Start Stimulus
const application = Application.start()
window.Stimulus = application // Make Stimulus globally available for debugging

// Automatically load all controllers
//const context = require.context("./controllers", true, /\.js$/)
//application.load(definitionsFromContext(context))

import SignatureController from "./controllers/signature_controller"
import TotalController from "./controllers/total_controller"
import HamburgerController from "./controllers/hamburger_controller"
import HighchartsController from "./controllers/highcharts_controller"
import AccordionController from "./controllers/accordion_controller"
import SearchController from "./controllers/search_controller"

// Register controllers manually
application.register("signature", SignatureController)
application.register("total", TotalController)
application.register("hamburger", HamburgerController) // Register hamburger controller
application.register("highcharts", HighchartsController) // Register Highcharts controller with the correct name
application.register("accordion", AccordionController)
application.register("search", SearchController)

// Optionally listen for Turbo page load events if you're using Turbo
document.addEventListener("turbo:load", () => {
  console.log(
    "Turbo page load detected - Stimulus controllers should be initialized"
  )
})

// Debugging logs
console.log("✅ Stimulus initialized")
console.log("✅ Registered controllers:", application.controllers)
