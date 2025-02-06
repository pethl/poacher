import { Controller } from "@hotwired/stimulus"
import SignaturePad from "signature_pad"

export default class extends Controller {
  static targets = ["canvas", "input"]

  connect() {
    console.log("Signature controller connected!")
    this.canvas = this.canvasTarget
    console.log(this.canvas)

    if (!this.canvas) {
      console.error("Canvas element not found!")
      return
    }

    if (this.canvas instanceof HTMLCanvasElement) {
      this.signaturePad = new SignaturePad(this.canvas)
      console.log("Signature Pad initialized:", this.signaturePad)
    } else {
      console.error("Canvas element is not a valid HTMLCanvasElement.")
    }

    this.signaturePad = new SignaturePad(this.canvas)
    console.log(this.signaturePad)

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
    try {
      console.log(
        "Checking if signature pad is empty:",
        this.signaturePad.isEmpty()
      )

      // Only try to save the signature if it's not empty
      if (!this.signaturePad.isEmpty()) {
        console.log("Attempting to generate signature data...")

        // Generate base64 data URL for the signature
        const signatureData = this.signaturePad.toDataURL()

        // Log the signature data
        console.log("Generated signature data:", signatureData)

        // Set the signature data in the hidden input field
        this.inputTarget.value = signatureData
        console.log("Signature data set to input:", this.inputTarget.value)

        console.log("Signature saved to input field")
      } else {
        console.log("No signature to save.")
      }
    } catch (error) {
      console.error("Error while saving signature:", error)
    }
  }
}
