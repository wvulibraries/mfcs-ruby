import {Controller} from "stimulus";
import Validation from "../components/validation/validation";
let debounce = require('lodash/debounce');

export default class GeneralValidations extends Controller {

  // initialize
  // -------------------------------------------------------------
  // creates a debounce effect on initialization
  // this debounce effect comes from lodash and plays an important role 
  // it will not allow this function to be called until 1 second has elapsed
  // between calls.  
  // @author: David J. Davis
  initialize(){
    this.validName = debounce(this.validName, 1000).bind(this)
  }

  // objectForm(e)
  // -------------------------------------------------------------
  // click event
  // Sets up an object form using the appropriate fields.
  // @author: David J. Davis
  validName(e){
    let input = e.target.value; 
    if(Validation.checkForSpaces(input)){ 
      e.target.parentNode.classList.add('field_with_errors'); 
      e.target.parentNode.querySelector('.error-issue').classList.remove('d-none');
      e.target.parentNode.querySelector('.error-issue').classList.add('d-block');
    } else { 
      e.target.parentNode.classList.remove('field_with_errors'); 
      e.target.parentNode.querySelector('.error-issue').classList.remove('d-block');
      e.target.parentNode.querySelector('.error-issue').classList.add('d-none');
    }
  }

}