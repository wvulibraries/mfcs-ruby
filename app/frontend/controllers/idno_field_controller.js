import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ["systemField"]
  
  // connect()
  // ------------------------------------------------------------
  // base load event in stimulus where the connections are made
  // using to hide fields that need to be hidden
  // @author: David J. Davis
  // connect(){   
  //   this.textFieldTarget.classList.add('d-none');
  //   this.urlFieldTarget.classList.add('d-none');
  //   return true
  // }

  // select(event)
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  select(e) {
    if(e.target.value == 'system'){ 
      this.systemFieldTarget.classList.remove('d-none');
    } else { 
      this.systemFieldTarget.classList.add('d-none');
    }
    
   
    // this.textFieldTarget.classList.remove('d-block');
    // this.urlFieldTarget.classList.remove('d-block');

    // if(e.target.value == 1 || e.target.value == 2){ 
    //   console.log('help text / html'); 
    //   this.textFieldTarget.classList.add('d-block');
    //   this.urlFieldTarget.classList.add('d-none');
    // } else if(e.target.value == 3){ 
    //   console.log('url'); 
    //   this.urlFieldTarget.classList.add('d-block');
    //   this.textFieldTarget.classList.add('d-none');
    // } else { 
    //   console.log('none');
    //   this.textFieldTarget.classList.add('d-none');
    //   this.urlFieldTarget.classList.add('d-none');
    // }
  }
}