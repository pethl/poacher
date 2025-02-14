import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "stimulus"
import { Controller } from "stimulus"

// Initialize Stimulus application
const application = Application.start()

// Import your custom controllers manually
import SignatureController from "./controllers/signature_controller"
import TotalController from "./controllers/total_controller"

// Register controllers manually
application.register("signature", SignatureController)
application.register("total", TotalController)

// Optionally listen for Turbo page load events if you're using Turbo
document.addEventListener("turbo:load", () => {
  console.log(
    "Turbo page load detected - Stimulus controllers should be initialized"
  )
})
