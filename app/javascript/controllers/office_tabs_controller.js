import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "everydayButton",
    "adminButton",
    "everydayPanel",
    "adminPanel"
  ]

  showEveryday() {
    this.everydayPanelTarget.classList.remove("hidden")
    this.adminPanelTarget.classList.add("hidden")

    this.everydayButtonTarget.classList.add(
      "bg-white",
      "shadow",
      "font-semibold",
      "text-gray-900"
    )

    this.everydayButtonTarget.classList.remove(
      "text-gray-600"
    )

    this.adminButtonTarget.classList.remove(
      "bg-white",
      "shadow",
      "font-semibold",
      "text-gray-900"
    )

    this.adminButtonTarget.classList.add(
      "text-gray-600"
    )
  }

  showAdmin() {
    this.adminPanelTarget.classList.remove("hidden")
    this.everydayPanelTarget.classList.add("hidden")

    this.adminButtonTarget.classList.add(
      "bg-white",
      "shadow",
      "font-semibold",
      "text-gray-900"
    )

    this.adminButtonTarget.classList.remove(
      "text-gray-600"
    )

    this.everydayButtonTarget.classList.remove(
      "bg-white",
      "shadow",
      "font-semibold",
      "text-gray-900"
    )

    this.everydayButtonTarget.classList.add(
      "text-gray-600"
    )
  }
}