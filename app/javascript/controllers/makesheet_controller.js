// app/javascript/controllers/makesheet_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    // salt/yield inputs
    "milkUsed",
    "expectedYield",
    "saltNet",
    "saltGross",

    // rennet
    "rennetWeight",

    // summary display slots
    "product",
    "makeDate",
    "number",
    "weight",
    "comments",
    "output",
    "flags"
  ]

  static values = {
    makeType: String, // e.g. "Red" (affects salt factor)
    bucketWeight: Number // optional; defaults to 1.6 kg if not provided
  }

  connect() {
    console.log("✅ Makesheet controller connected on:", this.element)

    // Live updates from Milk / Expected Yield
    if (this.hasMilkUsedTarget) {
      this.milkUsedTarget.addEventListener("input", () => {
        this.updateSaltWeights()
        this.fetchRennetSuggestion() // fetch rennet when milk changes
      })
    }
    if (this.hasExpectedYieldTarget) {
      this.expectedYieldTarget.addEventListener(
        "input",
        this.updateSaltWeights.bind(this)
      )
    }

    // If user edits Net manually, keep Gross = Net + bucket tare
    if (this.hasSaltNetTarget) {
      this.saltNetTarget.addEventListener(
        "input",
        this.updateGrossFromNet.bind(this)
      )
    }

    // Track manual edits on rennet so we don't overwrite user's value
    if (this.hasRennetWeightTarget) {
      this.rennetWeightTarget.addEventListener(
        "input",
        this.markDirty.bind(this)
      )
    }

    // Initial compute/suggestion if values are present
    this.updateSaltWeights()
    this.fetchRennetSuggestion()

    // “select triggers summary” behavior
    if (this.element.tagName === "SELECT") {
      this.element.addEventListener("change", this.loadSummary.bind(this))
    }
  }

  // ========== Rennet suggestion ==========
  fetchRennetSuggestion = this.#debounce(() => {
    if (!this.hasMilkUsedTarget || !this.hasRennetWeightTarget) return

    const milk = parseFloat(this.milkUsedTarget.value || "0")
    if (!milk || isNaN(milk)) {
      // If milk cleared and the user didn't edit rennet manually, clear suggestion
      if (this.rennetWeightTarget.dataset.dirty !== "true") {
        this.rennetWeightTarget.value = ""
      }
      return
    }

    // Only auto-fill if user hasn't manually edited rennet
    if (this.rennetWeightTarget.dataset.dirty === "true") return

    const url = `/makesheets/rennet_for_milk?milk_volume=${encodeURIComponent(milk)}`
    fetch(url, { headers: { Accept: "application/json" } })
      .then((r) => (r.ok ? r.json() : Promise.reject(r)))
      .then(({ rennet }) => {
        console.debug("🧪 rennet_for_milk", { milk, rennet })
        if (rennet == null) return
        const n = parseFloat(rennet)
        if (!isNaN(n)) this.rennetWeightTarget.value = this.#round3(n)
      })
      .catch((err) => {
        console.warn("rennet lookup failed", err)
        // silently ignore; keep user value if any
      })
  }, 200)

  // Mark inputs as user-edited so autofill won't overwrite
  markDirty(event) {
    event.currentTarget.dataset.dirty = "true"
  }

  // ========== Salt logic ==========
  updateSaltWeights() {
    if (!this.hasMilkUsedTarget || !this.hasExpectedYieldTarget) return

    const milkUsed = parseFloat(this.milkUsedTarget.value || "0")
    const expectedYield = parseFloat(this.expectedYieldTarget.value || "0")
    const bucketWeight = Number.isFinite(this.bucketWeightValue)
      ? this.bucketWeightValue
      : 1.6

    if (!milkUsed || !expectedYield) {
      this.#setSaltFields("", "")
      return
    }

    const saltFactor = this.makeTypeValue === "Red" ? 0.00021 : 0.0002
    const saltNet = milkUsed * expectedYield * saltFactor
    const saltGross = saltNet + bucketWeight

    this.#setSaltFields(this.#round3(saltNet), this.#round3(saltGross))
  }

  // Keep Gross in sync if Net is edited manually
  updateGrossFromNet() {
    if (!this.hasSaltNetTarget || !this.hasSaltGrossTarget) return
    const bucketWeight = Number.isFinite(this.bucketWeightValue)
      ? this.bucketWeightValue
      : 1.6
    const net = parseFloat(this.saltNetTarget.value || "0")
    if (!net) {
      this.saltGrossTarget.value = ""
      return
    }
    const gross = net + bucketWeight
    this.saltGrossTarget.value = this.#round3(gross)
  }

  #setSaltFields(net, gross) {
    if (this.hasSaltNetTarget) {
      this.saltNetTarget.value = net
      this.saltNetTarget.placeholder = ""
    }
    if (this.hasSaltGrossTarget) {
      this.saltGrossTarget.value = gross
      this.saltGrossTarget.placeholder = ""
    }
  }

  #round3(n) {
    if (n === "" || !Number.isFinite(n)) return ""
    return (Math.round((n + Number.EPSILON) * 1000) / 1000).toFixed(3)
  }

  #debounce(fn, wait) {
    let t
    return (...args) => {
      clearTimeout(t)
      t = setTimeout(() => fn.apply(this, args), wait)
    }
  }

  // ========== Summary fetching ==========
  loadSummary() {
    const makesheetId =
      (this.hasOutputTarget && this.outputTarget.value) || this.element.value
    if (!makesheetId) return

    fetch(`/makesheets/${makesheetId}/summary`)
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok")
        return response.json()
      })
      .then((data) => this.updateSummaryDisplay(data))
      .catch((error) =>
        console.error("❌ Failed to fetch makesheet summary:", error)
      )
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
