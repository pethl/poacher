import { Controller } from "@hotwired/stimulus"
import SignaturePad from "signature_pad"

import { Controller } from "@hotwired/stimulus"
import SignaturePad from "signature_pad"

export default class extends Controller {
  static targets = ["canvas", "input"]

  connect() {
    console.log("Signature controller connected!")
    this.canvas = this.canvasTarget

    if (!this.canvas) {
      console.error("Canvas element not found!")
      return
    }

    this.signaturePad = new SignaturePad(this.canvas)

    // Resize canvas for proper drawing
    this.resizeCanvas()
    window.addEventListener("resize", this.resizeCanvas.bind(this))
  }

  resizeCanvas() {
    const ratio = Math.max(window.devicePixelRatio || 1, 1)
    this.canvas.width = this.canvas.offsetWidth * ratio
    this.canvas.height = this.canvas.offsetHeight * ratio
    this.canvas.getContext("2d").scale(ratio, ratio)
    this.signaturePad.clear()
    console.log("Canvas resized and Signature Pad reinitialized.")
  }

  clear() {
    this.signaturePad.clear()
    this.inputTarget.value = "" // Clear hidden input field
    console.log("Signature Pad cleared.")
  }

  save() {
    if (!this.signaturePad.isEmpty()) {
      const signatureData = this.signaturePad.toDataURL()
      this.inputTarget.value = signatureData
      console.log("Signature saved to hidden input.")
    } else {
      console.log("No signature to save.")
    }
  }
}
