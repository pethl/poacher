import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    href: String
  }

  connect() {
    this.element.style.cursor = "pointer"
  }

  visit(event) {
    // prevent from triggering if clicking inside a link
    if (!event.target.closest("a")) {
      window.location = this.hrefValue
    }
  }
}
