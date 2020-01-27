import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ["systemField", "select"]
  
  // connect()
  // ------------------------------------------------------------
  // base load event in stimulus where the connections are made
  // using to hide fields that need to be hidden
  // @author: David J. Davis
  connect(){   
    if(this.selectTarget.value.toLowerCase() == 'system'){ 
      this.systemFieldTarget.classList.remove('d-none');
    } else { 
      this.systemFieldTarget.classList.add('d-none');
    }
  }

  // select(event)
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  selectType(e) {
    if(e.target.value.toLowerCase() == 'system'){ 
      this.systemFieldTarget.classList.remove('d-none');
    } else { 
      this.systemFieldTarget.classList.add('d-none');
    }
  }
}