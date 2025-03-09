import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["section"]

  connect() {
    console.log("✅ Accordion Controller Connected")
  }

  toggle(event) {
    event.preventDefault() // Stop the form submission
    event.stopPropagation() // Stop event bubbling

    console.log("Toggling accordion...", this.sectionTarget)

    if (this.hasSectionTarget) {
      this.sectionTarget.classList.toggle("hidden")
    } else {
      console.error("❌ No sectionTarget found.")
    }
  }
}
