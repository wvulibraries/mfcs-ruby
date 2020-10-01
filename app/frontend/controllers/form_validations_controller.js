import {Controller} from "stimulus";
import Validation from "../components/validation/validation";
let debounce = require('lodash/debounce');

export default class FormValidations extends Controller {

  // initialize
  // -------------------------------------------------------------
  // creates a debounce effect on initialization
  // this debounce effect comes from lodash and plays an important role 
  // it will not allow this function to be called until 1 second has elapsed
  // between calls.  
  // @author: David J. Davis
  initialize(){
    this.textLength = debounce(this.textLength, 1000).bind(this);
    this.duplicates = debounce(this.duplicates, 1000).bind(this);
  }

  // // objectForm(e)
  // // -------------------------------------------------------------
  // // click event
  // // Sets up an object form using the appropriate fields.
  // // @author: David J. Davis
  // validName(e){
  
  // }


  // duplicates(e)
  // -------------------------------------------------------------
  // keyup event
  // Does an Ajax Call to check validation on the input
  // @author: David J. Davis
  duplicates(e){ 
    console.log(e.target);
    console.log('duplications fired!'); 
  }

  // textLength(e)
  // -------------------------------------------------------------
  // key up event
  // Does an Ajax Call to check validation on the input
  // @author: David J. Davis
  textLength(e){ 
    let validation_target = e.target; 
    
    const params = new URLSearchParams({
      txt_string: validation_target.value,
      min: validation_target.dataset.min,
      max: validation_target.dataset.max,
      type: validation_target.dataset.format,
    });

    let url = '/api/v1/validate/textlength/?' + params.toString();
    
    fetch(url, {
      method: "GET",
      headers: {
        "api_key": "something",
        "Content-Type": "application/json", 
      }
    })
    .then(resp => resp.json())
    .then(function(data) {
      let validation_result = data.status;
      let validation_message = data.message;
      let feedbackElm = validation_target.parentNode.querySelector('.feedback');
      feedbackElm.innerHTML = validation_message;
      
      if(validation_result == true){ 
        validation_target.classList.remove('is-invalid');
        feedbackElm.classList.remove('invalid-feedback');

        validation_target.classList.add('is-valid');
        feedbackElm.classList.add('valid-feedback');
      } else{ 
        validation_target.classList.add('is-invalid');
        feedbackElm.classList.add('invalid-feedback');

        validation_target.classList.remove('.is-valid');
        feedbackElm.classList.remove('.valid-feedback');
      }
    })
    .catch(function(error) {
      console.error('Error with the API, please contact developers.'); 
    });
  }

}