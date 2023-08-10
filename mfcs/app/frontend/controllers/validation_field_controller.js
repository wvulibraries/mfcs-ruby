import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ["regexContainer", "regexField", "validationSelect"]
  
  // connect()
  // ------------------------------------------------------------
  // Stimulus Base override
  // @author: David J. Davis
  connect(){   
    this.regexContainerTarget.classList.add('d-none');
    return true
  }

  // validateRegex(e)
  // ------------------------------------------------------------
  // Test the regex to make sure it is valid on the fly.
  validRegex(e){ 
    let feedbackElm = this.regexContainerTarget.querySelector('.invalid-feedback');
    let parent = e.target.parentNode; 
    let valid = Validation.validRegex(e.target.value);
    if(valid){ 
      parent.classList.remove('field_with_errors');
      parent.querySelector('.invalid-feedback').classList.remove('d-block');
    } else { 
      parent.classList.add('field_with_errors'); 
      parent.querySelector('.invalid-feedback').classList.add('d-block');
    }
  }

  // select(event)
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  select(e) {
    if(e.target.value == 'regexp'){ 
      this.regexContainerTarget.classList.remove('d-none');
    } else { 
      this.regexContainerTarget.classList.add('d-none');
    }
  }
}