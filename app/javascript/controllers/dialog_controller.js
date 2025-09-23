// dialog_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "frame"]
  static values = { debug: Boolean, name: String }

  connect() {
    this._activeElement = null

    if (this.hasFrameTarget) {
      // Handle <iframe> PDFs
      this._onIFrameLoad = this.onIFrameLoad?.bind(this) || (() => {})
      this.frameTarget.addEventListener("load", this._onIFrameLoad)

      // Handle <turbo-frame> loads
      this._onFrameLoad = this.onFrameLoad?.bind(this)
      this.frameTarget.addEventListener("turbo:frame-load", this._onFrameLoad)

      this._onBeforeRender = (e) =>
        this.log("turbo:before-frame-render", {
          newHTMLLength: e.detail.newFrame?.innerHTML?.length
        })
      this.frameTarget.addEventListener(
        "turbo:before-frame-render",
        this._onBeforeRender
      )
    }

    this._onBeforeVisit = () => this.hide()
    document.addEventListener("turbo:before-visit", this._onBeforeVisit)
  }

  disconnect() {
    if (this.hasFrameTarget) {
      this.frameTarget.removeEventListener(
        "turbo:frame-load",
        this._onFrameLoad
      )
      this.frameTarget.removeEventListener(
        "turbo:before-frame-render",
        this._onBeforeRender
      )
      this.frameTarget.removeEventListener("load", this._onIFrameLoad)
    }
    document.removeEventListener("turbo:before-visit", this._onBeforeVisit)
  }

  open(event) {
    event?.preventDefault()
    event?.stopPropagation()
    event?.stopImmediatePropagation?.()

    this._activeElement = document.activeElement

    // Figure out which URL to show
    const clickedUrl = event?.currentTarget?.dataset?.url
    const frameUrl = this.hasFrameTarget ? this.frameTarget.dataset.src : null
    const url = clickedUrl || frameUrl

    // Show modal and lock page scroll + hide header
    this.backdropTarget.classList.remove("hidden")
    this.backdropTarget.classList.add("flex")
    document.documentElement.classList.add("overflow-hidden", "modal-open")

    // Lazy-load content into <iframe> or <turbo-frame>
    if (this.hasFrameTarget && url) {
      const needsChange =
        !this.frameTarget.hasAttribute("src") ||
        this.frameTarget.getAttribute("src") !== url

      if (needsChange) {
        // Keep a copy in data-src (useful for debugging)
        this.frameTarget.dataset.src = url
        // Defer so panel paints before network work begins
        requestAnimationFrame(() => this.frameTarget.setAttribute("src", url))
      }
    }

    // Move focus to a close button for accessibility
    const closeBtn = this.backdropTarget.querySelector(
      '[data-action~="dialog#close"]'
    )
    if (closeBtn) closeBtn.focus({ preventScroll: true })
  }

  close(event) {
    event?.preventDefault()
    event?.stopPropagation()
    event?.stopImmediatePropagation?.()
    this.hide()
  }

  hide() {
    // Hide modal and restore page scroll + header
    this.backdropTarget.classList.add("hidden")
    this.backdropTarget.classList.remove("flex")
    document.documentElement.classList.remove("overflow-hidden", "modal-open")

    // Clear frame src to stop PDF CPU usage / abort pending loads
    if (this.hasFrameTarget) {
      // For extra safety on some browsers, blank out before removing src
      // this.frameTarget.setAttribute("srcdoc", "")
      this.frameTarget.removeAttribute("src")
      // Keep data-src so next open can reuse if desired
    }

    // Return focus to the previously active element (if any)
    if (this._activeElement?.focus) {
      try {
        this._activeElement.focus({ preventScroll: true })
      } catch (_) {}
    }
  }

  keydown(event) {
    if (event.key === "Escape") {
      event.preventDefault()
      this.close()
    }
  }

  // optional: native iframe 'load' hook (good for hiding spinners, etc.)
  onIFrameLoad = () => {
    // Only log when the element is actually an iframe with a current src
    const src = this.frameTarget?.getAttribute?.("src")
    this.log("iframe: loaded", { src })
  }

  onFrameLoad(e) {
    const fetchResp = e?.detail?.fetchResponse
    this.log("frame: loaded", {
      src: this.frameTarget.getAttribute("src"),
      status: fetchResp?.response?.status,
      redirected: fetchResp?.redirected
    })
  }

  log(message, data = {}) {
    if (this.debugValue) {
      const label = this.hasNameValue ? this.nameValue : "dialog"
      const ts = new Date().toISOString()
      console.debug(`[${ts}] [${label}] ${message}`, data)
    }
  }
}
