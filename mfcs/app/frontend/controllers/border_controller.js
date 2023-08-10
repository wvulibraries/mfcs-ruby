import { Controller } from "stimulus";

export default class BorderController extends Controller {
  static targets = ["bordercolor"];

  setValue() {
    this.bordercolorTarget.setAttribute("value", this.bordercolorTarget.value);
  }
}