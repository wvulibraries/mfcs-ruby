// pagy_initializer_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    Pagy.init(this.element)
  }
}