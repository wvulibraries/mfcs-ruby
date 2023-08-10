import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class HelpField extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ["helpFields", "urlField", "textField", "select"]
  
  // connect()
  // ------------------------------------------------------------
  // base load event in stimulus where the connections are made
  // using to hide fields that need to be hidden
  // @author: David J. Davis
  connect(){   
    this.textFieldTarget.classList.add('d-none');
    this.urlFieldTarget.classList.add('d-none');
    return true
  }

  // validURL(e)
  // ------------------------------------------------------------
  // Uses the Validation library tested with Jest to see if the URL
  // is mostly valid.  This only eliminates improper formatting can
  // still be fooled.  
  // @author: David J. Davis
  validURL(e){ 
    let elm = e.target.value; 
    let parent = e.target.parentNode
    let valid = Validation.validUrl(elm); 
    if(valid){ 
      parent.classList.remove('field_with_errors');
      parent.querySelector('.invalid-feedback').classList.remove('d-block');
    } else { 
      parent.classList.add('field_with_errors'); 
      parent.querySelector('.invalid-feedback').classList.add('d-block');
    }
  }

  // modifyHTML(e)
  // ------------------------------------------------------------
  // Uses the Validation library tested with Jest to see if the URL
  // is mostly valid.  This only eliminates improper formatting can
  // still be fooled.  
  // @author: David J. Davis
  modifyHTML(e){ 
    let elm = e.target;
    let selectField = this.selectTarget; 
    if(selectField.value == 'plain_text'){ 
      elm.value = Validation.stripHTML(elm.value);
    } else { 
      elm.value = Validation.sanitizeInput(elm.value); 
    }
  }

  // select(event)
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  select(e) {
    this.textFieldTarget.classList.remove('d-block');
    this.urlFieldTarget.classList.remove('d-block');

    if(e.target.value == 'plain_text' || e.target.value == 'html_text'){ 
      this.textFieldTarget.classList.add('d-block');
      this.textFieldTarget.classList.remove('d-none');
      this.urlFieldTarget.classList.add('d-none');
    } else if(e.target.value == 'web_url'){ 
      this.urlFieldTarget.classList.add('d-block');
      this.urlFieldTarget.classList.remove('d-none');
      this.textFieldTarget.classList.add('d-none');
    } else { 
      this.textFieldTarget.classList.add('d-none');
      this.urlFieldTarget.classList.add('d-none');
    }
  }
}