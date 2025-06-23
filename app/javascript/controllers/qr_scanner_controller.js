import { Controller } from "@hotwired/stimulus"
import { Html5Qrcode } from "html5-qrcode"

export default class extends Controller {
  static targets = ["select", "message"]

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
    const match = decodedText.match(/\/locations\/(\d+)/)

    if (!match) {
      this.showMessage("⚠️ Invalid QR code (no location ID found)", true)
      return
    }

    const locationId = match[1]
    const options = this.selectTarget.options

    for (let i = 0; i < options.length; i++) {
      if (options[i].value === locationId) {
        this.selectTarget.selectedIndex = i
        this.selectTarget.dispatchEvent(new Event("change"))
        this.showMessage(`✅ Location found: ${options[i].text}`)
        return
      }
    }

    this.showMessage("⚠️ Location ID not found in the list", true)
  }

  showMessage(text, isError = false) {
    if (this.hasMessageTarget) {
      this.messageTarget.textContent = text
      this.messageTarget.className = isError
        ? "text-red-600 text-sm mt-2"
        : "text-green-600 text-sm mt-2"
    }
  }
}
