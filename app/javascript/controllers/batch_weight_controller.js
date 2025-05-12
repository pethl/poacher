import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="batch-weight"
export default class extends Controller {
  static targets = [
    "makesheetSelect",
    "gradeHeading",
    "washedBatchWeight", // hidden input
    "washedBatchWeightDisplay", // visual display
    "totalWaste", // hidden input
    "totalWasteDisplay", // visual display
    "wastePercentage"
  ]

  connect() {
    // console.log("✅ BatchWeightController connected")
  }

  fetch() {
    // Ensure makesheetSelect is present and enabled
    if (!this.hasMakesheetSelectTarget || this.makesheetSelectTarget.disabled) {
      console.warn("⚠️ Makesheet select field not available or disabled.")
      return
    }

    const makesheetId = this.makesheetSelectTarget.value
    if (!makesheetId) return

    fetch(`/makesheets/${makesheetId}/summary`)
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok")
        return response.json()
      })
      .then((data) => {
        console.log("🎯 Fetched summary data:", data)
        console.log("🧪 Washed batch weight check", {
          targetExists: this.hasWashedBatchWeightTarget,
          displayExists: this.hasWashedBatchWeightDisplayTarget,
          valueInData: data.total_weight_of_batch
        })

        // Grade
        if (this.hasGradeHeadingTarget) {
          this.gradeHeadingTarget.textContent = data.grade || ""
        }

        // Washed batch weight
        if (
          this.hasWashedBatchWeightTarget &&
          this.hasWashedBatchWeightDisplayTarget &&
          data.total_weight_of_batch !== null
        ) {
          const value = parseFloat(data.total_weight_of_batch).toFixed(2)
          this.washedBatchWeightTarget.value = value
          this.washedBatchWeightDisplayTarget.textContent = `${value} Kg`
        }

        // Total waste
        if (
          this.hasTotalWasteTarget &&
          this.hasTotalWasteDisplayTarget &&
          data.total_waste !== null
        ) {
          const value = parseFloat(data.total_waste).toFixed(2)
          this.totalWasteTarget.value = value
          this.totalWasteDisplayTarget.textContent = `${value} Kg`
        }

        this.recalculateWaste()
      })
      .catch((error) => {
        console.error("❌ Failed to fetch summary:", error)
      })
  }

  recalculateWaste() {
    if (
      !this.hasWashedBatchWeightTarget ||
      !this.hasTotalWasteTarget ||
      !this.hasWastePercentageTarget
    )
      return

    const washed = parseFloat(this.washedBatchWeightTarget.value)
    const waste = parseFloat(this.totalWasteTarget.value)

    if (!isNaN(washed) && washed > 0 && !isNaN(waste)) {
      const percentage = ((waste / washed) * 100).toFixed(2)
      this.wastePercentageTarget.textContent = `${percentage}%`
    } else {
      this.wastePercentageTarget.textContent = ""
    }
  }
}
