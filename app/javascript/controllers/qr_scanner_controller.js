import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  connect() {
    console.log("📦 QR Scanner connected")

    const html5QrCode = new Html5Qrcode("qr-reader")
    const config = { fps: 10, qrbox: 250 }

    html5QrCode
      .start(
        { facingMode: "environment" },
        config,
        this.onScanSuccess.bind(this)
      )
      .catch((err) => {
        console.error("❌ Camera access error:", err)
        document.getElementById("qr-reader").innerText =
          "Camera access error: " + err
      })

    this.html5QrCode = html5QrCode
  }

  onScanSuccess(decodedText) {
    console.log("✅ QR Code detected:", decodedText)

    const select = this.selectTarget
    const options = select.options
    const scanned = decodedText.trim().toLowerCase()

    let matchFound = false

    for (let i = 0; i < options.length; i++) {
      const text = options[i].text.trim().toLowerCase()
      console.log("🔍 Comparing with option:", text)

      if (text === scanned) {
        select.selectedIndex = i
        console.log("🎯 Match found, selected:", options[i].text)
        alert(`Scanned: ${options[i].text}`)
        matchFound = true
        break
      }
    }

    if (!matchFound) {
      console.warn("⚠️ No match found for:", scanned)
      alert("No matching location found.")
    }

    this.html5QrCode.stop().then(() => {
      document.getElementById("qr-reader").innerHTML =
        "<p class='text-green-600 text-sm'>Scan complete</p>"
    })
  }

  disconnect() {
    if (this.html5QrCode) {
      this.html5QrCode.stop().catch(() => {})
    }
  }
}
