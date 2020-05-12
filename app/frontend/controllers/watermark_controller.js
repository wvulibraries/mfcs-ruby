import {Controller} from "stimulus";

export default class Watermark extends Controller {

  // stimulus targets
  static targets = ["select", "container"]; 

  // create_form_field_options(e)
  // ------------------------------------------------------------
  // this toggles between metadata forms and manual choice values
  // @author: David J. Davis
  connect() {
    console.log('watermarks controller'); 
    let selectBox = this.selectTarget; 
    let url = `/api/v1/watermarks`;
    fetch(url, {
      method: "GET",
      headers: {
        "api_key": "something",
        "Content-Type": "application/json"
      }
    })
    .then(resp => resp.json())
    .then(function(data) {
      data.forEach(function(option){ 
        selectBox.add(new Option(option.name, option.id, false));
      });
    })
    .catch(function(error) {
      console.log(error);
      console.error('Error with the API, please contact developers.'); 
    });
  }

}