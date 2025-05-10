import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["graph", "table", "button", "graphTab", "tableTab"]

  connect() {
    console.log("✅ toggle-view controller loaded")
    this.showGraph() // default
  }

  showGraph() {
    this.graphTarget.classList.remove("hidden")
    this.tableTarget.classList.add("hidden")
    this.setActiveTab("graph")
  }

  showTable() {
    this.graphTarget.classList.add("hidden")
    this.tableTarget.classList.remove("hidden")
    this.setActiveTab("table")
  }

  setActiveTab(view) {
    const active = ["bg-gray-800", "text-white"]
    const inactive = ["bg-gray-100", "text-gray-800"]

    this.graphTabTarget.classList.remove(...active, ...inactive)
    this.tableTabTarget.classList.remove(...active, ...inactive)

    if (view === "graph") {
      this.graphTabTarget.classList.add(...active)
      this.tableTabTarget.classList.add(...inactive)
    } else {
      this.graphTabTarget.classList.add(...inactive)
      this.tableTabTarget.classList.add(...active)
    }
  }
}
