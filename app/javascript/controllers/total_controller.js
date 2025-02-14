import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sum"]

  initialize() {
    console.log("Total Controller initialized") // Check if this appears in the console
  }

  calculate() {
    const inputs = this.element.querySelectorAll('input[type="text"]')
    const total = Array.from(inputs)
      .map((input) => parseFloat(input.value) || 0)
      .reduce((sum, value) => sum + value, 0)

    this.sumTarget.textContent = total.toFixed(2)
  }
}
