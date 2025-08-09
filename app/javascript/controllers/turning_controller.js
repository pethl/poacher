import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit", "shed", "aisle"]

  connect() {
    this.update()
  }

  update() {
    const shedSelected = this.shedTargets.some((r) => r.checked)
    const aisleSelected = this.aisleTargets.some((r) => r.checked)
    this.submitTarget.disabled = !(shedSelected && aisleSelected)
  }
}
