import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("✅ Hamburger controller connected!")
  }

  toggle() {
    console.log("🍔 Toggle called")
    this.menuTarget.classList.toggle("hidden")
  }
}
