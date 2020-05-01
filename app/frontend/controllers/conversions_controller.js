import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class Conversions extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ['image', 'video', 'audio', 'border', 'thumbnail', 'thumbnailVideo', 'watermark']

  // change_options(e)
  // ------------------------------------------------------------
  // Maybe
  // @author: David J. Davis
  change_options(e){ 
    let displayTarget = e.target.dataset.displayTarget;
    let elmToDisplay = this.targets.find(displayTarget); 
    
    if(displayTarget != null && displayTarget.length != 0) { 
      if(e.target.checked == true) {
        elmToDisplay.classList.remove('d-none'); 
      } else { 
        elmToDisplay.classList.add('d-none'); 
      }
    }
  }
 
}