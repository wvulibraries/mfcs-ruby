import {Controller} from "stimulus"
export default class extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ["metadata-schema", "metadataFeilds"]

  // add
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  add(e) {
    e.preventDefault();
    var html = e.target.dataset.html; 
    this.metadataFeildsTarget.insertAdjacentHTML( 'beforeend', html);
  }

  // remove
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  remove(e) {
    e.preventDefault();  
    e.target.closest('div.metadata-row').remove();
  }
}