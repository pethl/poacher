import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "milkUsed",
    "expectedYield",
    "saltNet",
    "saltGross",
    "product",
    "makeDate",
    "number",
    "weight",
    "comments",
    "output",
    "flags"
  ]

  static values = {
    makeType: String
  }

  connect() {
    console.log("✅ Makesheet controller connected on:", this.element)

    if (this.hasMilkUsedTarget && this.hasExpectedYieldTarget) {
      this.updateSaltWeights()
    }

    if (this.element.tagName === "SELECT") {
      this.element.addEventListener("change", this.loadSummary.bind(this))
    }
  }

  // SALT LOGIC (same as before) ...

  loadSummary() {
    const makesheetId =
      (this.hasOutputTarget && this.outputTarget.value) || this.element.value
    console.log("🔍 loadSummary fired — found makesheetId:", makesheetId)
    if (!makesheetId) return

    fetch(`/makesheets/${makesheetId}/summary`)
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok")
        return response.json()
      })
      .then((data) => {
        console.log("📦 summary JSON returned", data)
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
    if (this.hasFlagsTarget) this.flagsTarget.innerHTML = data.flags || "-"
  }
}
