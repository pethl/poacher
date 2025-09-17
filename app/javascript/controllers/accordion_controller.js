import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["section"]

  connect() {
    // console.log("✅ Accordion Controller Connected", this.element)
  }

  toggle(event) {
    // type="button" already prevents form submits, but these are safe
    event.preventDefault()
    event.stopPropagation()

    // Prefer the section inside this controller instance
    let panel = this.hasSectionTarget ? this.sectionTarget : null

    // Fallback: find the nearest panel for the clicked header
    if (!panel) {
      const container = event.currentTarget.closest(
        "[data-controller='accordion']"
      )
      panel = container?.querySelector("[data-accordion-target='section']")
    }

    if (panel) {
      panel.classList.toggle("hidden")
      this._toggleAria(event.currentTarget)
    } else {
      console.error(
        "❌ No [data-accordion-target='section'] found for this accordion instance."
      )
    }
  }

  _toggleAria(button) {
    const expanded = button.getAttribute("aria-expanded") === "true"
    button.setAttribute("aria-expanded", String(!expanded))
  }
}
