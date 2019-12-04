import {Controller} from "stimulus"
export default class extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ["metadata-schema", "metadataFeilds", "template"]

  // add
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  add(e) {
    e.preventDefault();
    var html = this.templateTarget.innerHTML; 
    this.metadataFeildsTarget.insertAdjacentHTML( 'beforeend', html);
  }

  // remove
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  remove(e) {
    e.preventDefault();  
    if(this.metadataFeildsTarget.childElementCount > 1) { 
      e.target.closest('div.metadata-row').remove();
    }
  }
}