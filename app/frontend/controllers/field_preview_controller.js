import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // connect() 
  // -------------------------------------------------------------
  // default in stimulus as the function that fires when a page is 
  // loaded or added to the DOM. 
  // @author: David J. Davis
  connect() {
    const event = document.createEvent("CustomEvent")
    event.initCustomEvent("previewChange", true, true, null)
    this.element.dispatchEvent(event)
  }
}