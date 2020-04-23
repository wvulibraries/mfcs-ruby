import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class Conversions extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = []


  // change_options(e)
  // ------------------------------------------------------------
  // Maybe
  // @author: David J. Davis
  change_options(e){ 
    let elmToDisplay = this.targets.find(e.target.dataset.displayTarget); 
    
    if(e.target.checked == true) {
      elmToDisplay.classList.remove('d-none'); 
    } else { 
      elmToDisplay.classList.add('d-none'); 
    }
  }
 
}