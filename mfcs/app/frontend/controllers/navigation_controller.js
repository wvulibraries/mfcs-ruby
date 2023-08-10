import {Controller} from "stimulus";

export default class Navigation extends Controller {
  static targets = ["menu"]

  open(e){
    let menu = this.menuTarget;
    menu.classList.remove('invisible');
    menu.classList.add('visible');
  }

  close(e){ 
    let menu = this.menuTarget;
    menu.classList.remove('visible');
    menu.classList.add('invisible');
  }
}