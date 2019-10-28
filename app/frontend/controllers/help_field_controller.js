import {Controller} from "stimulus"
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

  // select(event)
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  select(e) {
    e.preventDefault();
    console.log(e.target.value);
    switch(e.target.value) { 
      case '1' || '2': 
        console.log('help text / html'); 
        this.textFieldTarget.classList.add('d-block');
        break;
      case '3': 
        console.log('url'); 
        this.urlFieldTarget.classList.add('d-block');
        break; 
      default: 
        console.log('idk wtf is going on');
    }
  }
}