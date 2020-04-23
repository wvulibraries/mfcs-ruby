import { Controller } from "stimulus";

export default class BasicController extends Controller {
  static targets = ["input", "output"];

  copy() {
    this.targets.find("output").value =
      this.targets.find("input").value;
  }
}