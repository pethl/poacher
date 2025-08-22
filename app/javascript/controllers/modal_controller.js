import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "frame"]
  static values = { debug: Boolean, name: String }

  connect() {
    this.log("connect", {
      hasFrameTarget: this.hasFrameTarget,
      frameDataSrc: this.hasFrameTarget ? this.frameTarget.dataset.src : null
    })

    this._activeElement = null

    if (this.hasFrameTarget) {
      this._onFrameLoad = this.onFrameLoad.bind(this)
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

    // If a navigation happens while open, make sure the modal hides
    this._onBeforeVisit = () => this.hide()
    document.addEventListener("turbo:before-visit", this._onBeforeVisit)
  }

  disconnect() {
    this.log("disconnect")

    if (this.hasFrameTarget) {
      this.frameTarget.removeEventListener(
        "turbo:frame-load",
        this._onFrameLoad
      )
      this.frameTarget.removeEventListener(
        "turbo:before-frame-render",
        this._onBeforeRender
      )
    }

    document.removeEventListener("turbo:before-visit", this._onBeforeVisit)
  }

  open(event) {
    if (event) {
      event.preventDefault()
      event.stopPropagation()
      event.stopImmediatePropagation?.()
    }

    this.log("open: click", {
      wasVisible: !this.backdropTarget.classList.contains("hidden")
    })

    // remember focus so we can restore it later
    this._activeElement = document.activeElement

    this.backdropTarget.classList.remove("hidden")
    this.backdropTarget.classList.add("flex")
    document.documentElement.classList.add("overflow-hidden") // lock scroll

    if (
      this.hasFrameTarget &&
      this.frameTarget.dataset.src &&
      !this.frameTarget.hasAttribute("src")
    ) {
      this.log("open: setting frame src", { src: this.frameTarget.dataset.src })
      // small defer so the panel paints before loading
      requestAnimationFrame(() =>
        this.frameTarget.setAttribute("src", this.frameTarget.dataset.src)
      )
    } else {
      this.log("open: frame already set or missing", {
        hasFrameTarget: this.hasFrameTarget,
        dataSrc: this.hasFrameTarget ? this.frameTarget.dataset.src : null,
        hasSrcAttr: this.hasFrameTarget
          ? this.frameTarget.hasAttribute("src")
          : null
      })
    }

    // move focus to close button for a11y
    const closeBtn = this.backdropTarget.querySelector(
      '[data-action~="modal#close"]'
    )
    if (closeBtn) closeBtn.focus({ preventScroll: true })
  }

  close(event) {
    if (event) {
      event.preventDefault()
      event.stopPropagation()
      event.stopImmediatePropagation?.()
    }
    this.log("close: attempt", { target: event?.target?.nodeName })
    this.hide()
  }

  hide() {
    this.backdropTarget.classList.add("hidden")
    this.backdropTarget.classList.remove("flex")
    document.documentElement.classList.remove("overflow-hidden")

    // restore focus to what was active before opening
    if (this._activeElement?.focus) {
      try {
        this._activeElement.focus({ preventScroll: true })
      } catch (_) {}
    }

    this.log("close: closed")
  }

  keydown(event) {
    this.log("keydown", { key: event.key })
    if (event.key === "Escape") {
      event.preventDefault()
      this.close()
    }
  }

  onFrameLoad(e) {
    const fetchResp = e?.detail?.fetchResponse
    this.log("frame: loaded", {
      src: this.frameTarget.getAttribute("src"),
      status: fetchResp?.response?.status,
      redirected: fetchResp?.redirected
    })
  }

  // ---- helpers ----
  log(message, data = {}) {
    if (this.debugValue) {
      const label = this.hasNameValue ? this.nameValue : "modal"
      const ts = new Date().toISOString()
      // eslint-disable-next-line no-console
      console.debug(`[${ts}] [${label}] ${message}`, data)
    }
  }
}
