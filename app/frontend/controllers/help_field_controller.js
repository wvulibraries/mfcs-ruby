import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ["helpFields", "urlField", "textField"]
  
  // connect()
  // ------------------------------------------------------------
  // base load event in stimulus where the connections are made
  // using to hide fields that need to be hidden
  // @author: David J. Davis
  connect(){   
    this.textFieldTarget.classList.add('d-none');
    this.urlFieldTarget.classList.add('d-none');
  }

  validURL(e){ 
    console.log(Validation.validUrl(e.target.value));
  }

  // select(event)
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  select(e) {
    this.textFieldTarget.classList.remove('d-block');
    this.urlFieldTarget.classList.remove('d-block');

    if(e.target.value == 1 || e.target.value == 2){ 
      console.log('help text / html'); 
      this.textFieldTarget.classList.add('d-block');
      this.urlFieldTarget.classList.add('d-none');
    } else if(e.target.value == 3){ 
      console.log('url'); 
      this.urlFieldTarget.classList.add('d-block');
      this.textFieldTarget.classList.add('d-none');
    } else { 
      console.log('none');
      this.textFieldTarget.classList.add('d-none');
      this.urlFieldTarget.classList.add('d-none');
    }
  }
}