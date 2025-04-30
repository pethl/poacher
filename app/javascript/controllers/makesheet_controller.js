import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["milkUsed", "expectedYield", "saltNet", "saltGross"]
  static values = { makeType: String }

  connect() {
    console.log("✅ Makesheet controller connected")
    this.updateSaltWeights()
  }

  updateSaltWeights() {
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
      this.saltNetTarget.placeholder = ""
      this.saltGrossTarget.placeholder = ""
      return
    }

    // Use Red-specific salt factor
    const saltFactor = this.makeTypeValue === "Red" ? 0.00021 : 0.0002

    const saltNet = milkUsed * expectedYield * saltFactor
    const saltGross = saltNet + bucketWeight

    this.saltNetTarget.placeholder = saltNet.toFixed(3)
    this.saltGrossTarget.placeholder = saltGross.toFixed(3)
  }
}
