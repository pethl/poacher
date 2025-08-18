import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "total", "remaining"]
  static values = { totalInBatch: Number }

  connect() {
    console.log("🧀 CheeseWash controller connected!")
    this.update()
  }

  update() {
    let sum = 0

    this.inputTargets.forEach((input) => {
      const qty = parseInt(input.value) || 0
      sum += qty

      if (qty > 0) {
        // auto-fill associated date field if blank
        const numberInputId = input.getAttribute("id") // e.g. number_washed_5
        const rowNumber = numberInputId.split("_").pop() // "5"
        const dateField = document.getElementById(`wash_date_${rowNumber}`)

        if (dateField && !dateField.value) {
          const today = new Date().toISOString().slice(0, 10) // yyyy-mm-dd
          dateField.value = today
        }
      }
    })

    this.totalTarget.textContent = sum

    if (this.hasRemainingTarget && this.totalInBatchValue) {
      this.remainingTarget.textContent = this.totalInBatchValue - sum
    }
  }
}
