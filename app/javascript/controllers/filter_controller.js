// app/javascript/controllers/filter_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "row"]

  connect() {
    console.log("✅ FilterController connected")
  }

  filter() {
    const query = this.inputTarget.value.toLowerCase()

    this.rowTargets.forEach((row) => {
      const text = row.textContent.toLowerCase()
      row.style.display = text.includes(query) ? "" : "none"
    })
  }
}
