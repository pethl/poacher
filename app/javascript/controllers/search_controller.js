import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  submitForm() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300) // Debounce to avoid excessive requests
  }
}
