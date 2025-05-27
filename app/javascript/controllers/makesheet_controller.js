import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    // Original makesheet calculation targets
    "milkUsed",
    "expectedYield",
    "saltNet",
    "saltGross",

    // Cheese wash summary display targets
    "product",
    "makeDate",
    "number",
    "weight",
    "comments"
  ]

  static values = {
    makeType: String
  }

  connect() {
    console.log("✅ Makesheet controller connected")

    // Only run salt logic if on Makesheet form
    if (this.hasMilkUsedTarget && this.hasExpectedYieldTarget) {
      this.updateSaltWeights()
    }

    // Only attach summary loader if on Cheese Wash form
    if (this.element.tagName === "SELECT") {
      this.element.addEventListener("change", this.loadSummary.bind(this))
    }
  }

  // ========== Original salt logic ==========
  updateSaltWeights() {
    if (!this.hasMilkUsedTarget || !this.hasExpectedYieldTarget) return

    const milkUsed = parseFloat(this.milkUsedTarget.value || 0)
    const expectedYield = parseFloat(this.expectedYieldTarget.value || 0)
    const bucketWeight = parseFloat(
      this.expectedYieldTarget.dataset.bucketWeight || 0
    )

    if (
      isNaN(milkUsed) ||
      isNaN(expectedYield) ||
      milkUsed === 0 ||
      expectedYield === 0
    ) {
      if (this.hasSaltNetTarget) this.saltNetTarget.placeholder = ""
      if (this.hasSaltGrossTarget) this.saltGrossTarget.placeholder = ""
      return
    }

    const saltFactor = this.makeTypeValue === "Red" ? 0.00021 : 0.0002
    const saltNet = milkUsed * expectedYield * saltFactor
    const saltGross = saltNet + bucketWeight

    if (this.hasSaltNetTarget)
      this.saltNetTarget.placeholder = saltNet.toFixed(3)
    if (this.hasSaltGrossTarget)
      this.saltGrossTarget.placeholder = saltGross.toFixed(3)
  }

  // ========== New cheese wash summary logic ==========
  loadSummary() {
    const makesheetId = this.element.value
    if (!makesheetId) return

    fetch(`/makesheets/${makesheetId}/summary`)
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok")
        return response.json()
      })
      .then((data) => {
        this.updateSummaryDisplay(data)
      })
      .catch((error) => {
        console.error("❌ Failed to fetch makesheet summary:", error)
      })
  }

  updateSummaryDisplay(data) {
    if (this.hasProductTarget)
      this.productTarget.textContent = data.grade || "-"
    if (this.hasMakeDateTarget)
      this.makeDateTarget.textContent = data.make_date || "-"
    if (this.hasNumberTarget)
      this.numberTarget.textContent = data.number_of_cheeses || "-"
    if (this.hasWeightTarget)
      this.weightTarget.textContent = data.total_weight || "-"
    if (this.hasCommentsTarget)
      this.commentsTarget.textContent = data.post_make_notes || "-"
  }
}
