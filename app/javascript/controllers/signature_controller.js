import { Controller } from "@hotwired/stimulus"
import SignaturePad from "signature_pad"

export default class extends Controller {
  connect() {
    this.canvas = this.element.querySelector("canvas")
    this.signaturePad = new SignaturePad(this.canvas)
    this.clearButton = this.element.querySelector(".clear-signature")
    this.hiddenInput = this.element.querySelector(".signature-input")

    // Handle Clear Button
    this.clearButton.addEventListener("click", () => {
      this.signaturePad.clear()
      this.hiddenInput.value = ""
    })

    // Store Signature Before Form Submit
    this.element.closest("form").addEventListener("submit", () => {
      if (!this.signaturePad.isEmpty()) {
        this.hiddenInput.value = this.signaturePad.toDataURL() // Save as Base64
      }
    })
  }
}
