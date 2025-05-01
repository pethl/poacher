import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="traceability"
export default class extends Controller {
  static targets = [
    "select",
    "batchCode",
    "numberOfCheeses",
    "totalWeight",
    "cheeseCountDisplay",
    "cheeseWeightTotalDisplay",
    "cheeseWeight"
  ]

  connect() {
    // Clean, no unsaved-change logic
  }

  updateCheeseStats() {
    let total = 0
    let count = 0

    this.cheeseWeightTargets.forEach((input) => {
      const val = parseFloat(input.value)
      if (!isNaN(val)) {
        total += val
        count += 1
      }
    })

    this.cheeseCountDisplayTarget.textContent = count
    this.cheeseWeightTotalDisplayTarget.textContent = total.toFixed(2)
  }

  fetch() {
    const makesheetId = this.selectTarget.value
    if (!makesheetId) return

    fetch(`/makesheets/${makesheetId}/summary.json`)
      .then((response) => response.json())
      .then((data) => {
        this.batchCodeTarget.value = data.batch || ""
        this.numberOfCheesesTarget.textContent = data.number_of_cheeses || "--"
        this.totalWeightTarget.textContent = data.total_weight || "--"
      })
      .catch((error) => {
        console.error("Failed to fetch makesheet data:", error)
      })
  }
}
