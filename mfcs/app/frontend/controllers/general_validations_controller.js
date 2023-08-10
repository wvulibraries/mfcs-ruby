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

  // validName(e)
  // -------------------------------------------------------------
  // keyup event
  // Checks the name for spaces, spaces are not allowed.
  // @author: David J. Davis
  validName(e){
    let input = e.target.value; 
    let current_names = this.getNames();

    if(Validation.checkForSpaces(input)){ 
      e.target.parentNode.classList.add('field_with_errors'); 
      e.target.parentNode.querySelector('.error-issue').classList.remove('d-none');
      e.target.parentNode.querySelector('.error-issue').classList.add('d-block');
      e.target.parentNode.querySelector('.error-issue').innerHTML = 'Field may not have spaces in it, please replace spaces with `_` or `-`.';
    } else if(current_names.includes(input)){ 
      e.target.parentNode.classList.add('field_with_errors'); 
      e.target.parentNode.querySelector('.error-issue').classList.remove('d-none');
      e.target.parentNode.querySelector('.error-issue').classList.add('d-block');
      e.target.parentNode.querySelector('.error-issue').innerHTML = 'Duplicate name, can not name something the same as another field.';
    } else if(input.length == 0){ 
      e.target.parentNode.classList.add('field_with_errors'); 
      e.target.parentNode.querySelector('.error-issue').classList.remove('d-none');
      e.target.parentNode.querySelector('.error-issue').classList.add('d-block');
      e.target.parentNode.querySelector('.error-issue').innerHTML = 'All fields must have a valid name.';
    }else { 
      e.target.parentNode.classList.remove('field_with_errors'); 
      e.target.parentNode.querySelector('.error-issue').classList.remove('d-block');
      e.target.parentNode.querySelector('.error-issue').classList.add('d-none');
    }
  }

  getNames(){
    let preview_elms = document.querySelectorAll('.field-preview');
    let names_array = []
    preview_elms.forEach(elm => {
      let json = JSON.parse(elm.dataset.json.replace(/'/g, '"'));
      if(elm.classList.contains('active')){
        // do nothing
      } else { 
        names_array.push(json['name']); 
      }
    }); 
    return names_array;
  }



}