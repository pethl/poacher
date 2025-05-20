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
    "cheeseWeight",
    "gradeHeading"
  ]

  connect() {
    console.log("✅ TraceabilityController connected")

    // Only run fetch if select is enabled (i.e., on new form)
    if (!this.selectTarget.disabled) {
      this.fetch()
    }

    requestAnimationFrame(() => {
      this.updateCheeseStats()
    })
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
        if (
          this.hasBatchCodeTarget &&
          data.batch !== null &&
          data.batch !== ""
        ) {
          this.batchCodeTarget.value = data.batch
        }

        this.numberOfCheesesTarget.textContent = data.number_of_cheeses || "--"
        this.totalWeightTarget.textContent = data.total_weight || "--"
        this.gradeHeadingTarget.textContent = data.grade || ""
      })
      .catch((error) => {
        console.error("Failed to fetch makesheet data:", error)
      })
  }
}
