import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static targets = ["input", "output"]
  static values = {
    makesheets: Object // e.g., { "2025-07-11": 42, "2025-07-12": 43 }
  }

  connect() {
    console.log("🧠 MakesheetPicker connected")
    const enabledDates = Object.keys(this.makesheetsValue)
    console.log("📆 Enabled makesheet dates:", enabledDates)

    if (!this.hasInputTarget || !this.hasOutputTarget) {
      console.error("❌ Missing input or output target!")
      return
    }

    flatpickr(this.inputTarget, {
      enable: enabledDates,
      dateFormat: "Y-m-d",
      altInput: true,
      altFormat: "F j, Y",
      onChange: (selectedDates, dateStr) => {
        const isoDate = dateStr // "YYYY-MM-DD" per dateFormat
        const makesheetId = this.makesheetsValue[isoDate]
        console.log("📅 Selected:", isoDate)
        console.log("🔗 Found makesheet ID:", makesheetId)

        if (this.hasOutputTarget) {
          this.outputTarget.value = makesheetId || ""
          console.log("✅ Hidden field updated:", this.outputTarget)
        } else {
          console.warn("⚠️ Output target not found!")
        }
      }
    })
  }
}
