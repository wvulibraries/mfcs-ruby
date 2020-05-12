import {Controller} from "stimulus";

export default class extends Controller {
  // targets
  static targets = ['title', 'displayTitle', 'description', 'submitButton', 'updateButton']

  // titleChange(event)
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  settingChange(e) {
    let modifiedText = e.target.value
    let targetItem = this.targets.find(e.target.dataset.preview)
    targetItem.innerHTML = modifiedText; 
  }
}