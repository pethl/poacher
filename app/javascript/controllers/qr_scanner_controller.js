// app/javascript/controllers/qr_scanner_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  connect() {
    const html5QrCode = new Html5Qrcode(this.element.id) // now global
    const config = { fps: 10, qrbox: 250 }

    html5QrCode
      .start(
        { facingMode: "environment" },
        config,
        this.onScanSuccess.bind(this)
      )
      .catch((err) => {
        this.element.innerText = "Camera access error: " + err
      })

    this.html5QrCode = html5QrCode
  }

  onScanSuccess(decodedText) {
    const select = this.selectTarget
    const options = select.options

    for (let i = 0; i < options.length; i++) {
      if (
        options[i].text.trim().toLowerCase() ===
        decodedText.trim().toLowerCase()
      ) {
        select.selectedIndex = i
        alert(`Scanned: ${options[i].text}`)
        break
      }
    }

    this.html5QrCode.stop().then(() => {
      this.element.innerHTML =
        "<p class='text-green-600 text-sm'>Scan complete</p>"
    })
  }

  disconnect() {
    if (this.html5QrCode) {
      this.html5QrCode.stop().catch(() => {})
    }
  }
}
