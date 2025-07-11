import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]
  static values = {
    makesheets: Object // { "2025-07-10": 12, "2025-07-11": 13 }
  }

  connect() {
    this.inputTarget.addEventListener("change", (event) => {
      const selectedDate = event.target.value
      const makesheetId = this.makesheetsValue[selectedDate]
      if (makesheetId) {
        this.outputTarget.value = makesheetId
      } else {
        this.outputTarget.value = ""
      }
    })
  }
}
