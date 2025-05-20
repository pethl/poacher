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
    this.updateDisplayFromHiddenFields()
  }

  fetch() {
    if (!this.hasMakesheetSelectTarget || this.makesheetSelectTarget.disabled)
      return

    const makesheetId = this.makesheetSelectTarget.value
    if (!makesheetId) return

    fetch(`/makesheets/${makesheetId}/summary`)
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok")
        return response.json()
      })
      .then((data) => {
        if (this.hasGradeHeadingTarget) {
          this.gradeHeadingTarget.textContent = data.grade || ""
        }

        if (
          this.hasWashedBatchWeightTarget &&
          this.hasWashedBatchWeightDisplayTarget &&
          data.total_weight_of_batch !== null
        ) {
          const value = parseFloat(data.total_weight_of_batch).toFixed(2)
          this.washedBatchWeightTarget.value = value
          this.washedBatchWeightDisplayTarget.textContent = `${value} Kg`
        }

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
        console.error("Failed to fetch makesheet summary:", error)
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

  updateDisplayFromHiddenFields() {
    if (
      this.hasWashedBatchWeightTarget &&
      this.hasWashedBatchWeightDisplayTarget
    ) {
      const washed = parseFloat(this.washedBatchWeightTarget.value)
      if (!isNaN(washed)) {
        this.washedBatchWeightDisplayTarget.textContent = `${washed.toFixed(2)} Kg`
      }
    }

    if (this.hasTotalWasteTarget && this.hasTotalWasteDisplayTarget) {
      const waste = parseFloat(this.totalWasteTarget.value)
      if (!isNaN(waste)) {
        this.totalWasteDisplayTarget.textContent = `${waste.toFixed(2)} Kg`
      }
    }

    this.recalculateWaste()
  }
}
