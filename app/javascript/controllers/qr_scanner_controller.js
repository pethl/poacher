import { Controller } from "@hotwired/stimulus"
import { Html5Qrcode } from "html5-qrcode"

export default class extends Controller {
  static targets = ["select"]

  connect() {
    this.startScanner()
  }

  startScanner() {
    const scanner = new Html5Qrcode("qr-reader")
    scanner.start(
      { facingMode: "environment" },
      {
        fps: 10,
        qrbox: 250
      },
      (decodedText) => this.handleScan(decodedText),
      (errorMessage) => {}
    )
  }

  handleScan(decodedText) {
    // Example: "https://poacher.../locations/8504"
    const match = decodedText.match(/\/locations\/(\d+)/)

    if (!match) {
      alert("Invalid QR code: No location ID found")
      return
    }

    const locationId = match[1]
    const options = this.selectTarget.options

    for (let i = 0; i < options.length; i++) {
      if (options[i].value === locationId) {
        this.selectTarget.selectedIndex = i
        this.selectTarget.dispatchEvent(new Event("change"))
        return
      }
    }

    alert("Location ID not found in the dropdown")
  }
}
