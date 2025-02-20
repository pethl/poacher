import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("Hamburger Controller connected!")
  }

  toggle() {
    console.log("✅ Hamburger menu toggled!")
    console.log(this.menuTarget) // This should show the DOM element

    // Log the current class list of the menu before any changes
    console.log("Current menu classes:", this.menuTarget.classList)

    // Check if the menu is currently hidden
    if (this.menuTarget.classList.contains("hidden")) {
      console.log("Menu is hidden, showing it now...")
      // Remove 'hidden' and add 'flex' to show the menu
      this.menuTarget.classList.remove("hidden")
      this.menuTarget.classList.add("flex")
    } else {
      console.log("Menu is visible, hiding it now...")
      // Remove 'flex' and add 'hidden' to hide the menu
      this.menuTarget.classList.remove("flex")
      this.menuTarget.classList.add("hidden")
    }

    // Log the class list again after toggling
    console.log("Updated menu classes:", this.menuTarget.classList)
  }
}
