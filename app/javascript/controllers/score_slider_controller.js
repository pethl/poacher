import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="score-slider"
export default class extends Controller {
  static targets = ["slider", "output"]

  connect() {
    this.updateOutput()
  }

  updateOutput() {
    if (this.hasSliderTarget && this.hasOutputTarget) {
      this.outputTarget.textContent = this.sliderTarget.value
    }
  }

  change() {
    this.updateOutput()
  }
}
