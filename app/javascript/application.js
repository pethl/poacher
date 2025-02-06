// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import SignatureController from "./controllers/signature_controller"

const application = Application.start()
console.log("Stimulus is loaded!")
application.register("signature", SignatureController)
