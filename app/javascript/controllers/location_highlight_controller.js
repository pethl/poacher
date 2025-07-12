// app/javascript/controllers/location_highlight_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("🚀 location-highlight connected")
    window.requestAnimationFrame(() => {
      setTimeout(() => {
        this.highlightLocation()
      }, 50) // short delay ensures DOM is rendered
    })
  }

  highlightLocation() {
    const hash = window.location.hash
    console.log("🔍 Hash found:", hash)
    if (hash) {
      const target = document.querySelector(hash)
      if (target) {
        console.log("✅ Found element:", target)
        target.classList.add("ring", "ring-4", "ring-blue-500", "animate-pulse")
        target.scrollIntoView({ behavior: "smooth", block: "center" })
      } else {
        console.warn("⚠️ No matching element for hash:", hash)
      }
    }
  }
}
