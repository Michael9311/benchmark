import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["anthropicModel", "openaiModel", "provider"]

  connect() {
    this.updateModelFields()
  }

  updateModelFields() {
    const providerValue = this.providerTarget.value
    
    if (providerValue === "anthropic") {
      this.anthropicModelTarget.style.display = "block"
      this.openaiModelTarget.style.display = "none"
    } else if (providerValue === "openai") {
      this.anthropicModelTarget.style.display = "none"
      this.openaiModelTarget.style.display = "block"
    }
  }
}