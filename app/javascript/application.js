// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import SignatureController from "./controllers/signature_controller"
import Chartkick from "chartkick"
import Chart from "chart.js"

// Add Chart.js as the adapter
Chartkick.addAdapter(Chart

const application = Application.start()
console.log("Stimulus is loaded!")
application.register("signature", SignatureController)
