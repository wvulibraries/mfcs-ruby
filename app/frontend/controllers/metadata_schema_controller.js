import {Controller} from "stimulus"
export default class extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ["metadata-schema", "metadatafields", "template", "hidden"]

  // add
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  add(e) {
    e.preventDefault();
    var html = this.templateTarget.innerHTML; 
    this.metadatafieldsTarget.insertAdjacentHTML( 'beforeend', html);
  }

  // remove
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  remove(e) {
    e.preventDefault();  
    if(this.metadatafieldsTarget.childElementCount > 1) { 
      e.target.closest('div.metadata-row').remove();
    }
  }

  // formatData(e)
  // -------------------------------------------------------------
  // grabs the html content from the Metadata Schema fields and sets it properly 
  // inside of the hidden field.  This will be the field we actually use.  
  // @author: David J. Davis
  formatData(e) {
    let hidden_field = this.hiddenTarget;
    let input_elms = this.metadatafieldsTarget.querySelectorAll("input, select");
    let data = []
    for (let i = 0; i < input_elms.length; i+=3){
      let tmp_obj = { }; 
      tmp_obj['schema'] = input_elms[i].value; 
      tmp_obj['identifier'] = input_elms[i+1].value;
      tmp_obj['qualifier'] = input_elms[i+2].value;
      data.push(tmp_obj);
    }
    hidden_field.value = JSON.stringify(data);
  }

  // reprocess
  // -------------------------------------------------------------
  // this is fired when a field is clicked on to update, or when it is created.
  // this should be fired so that the proper amount of fields show up for the number of options
  // available. 
  // @author: David J. Davis
  reprocess(e){
    e.preventDefault();
    console.log('reprocessing metadata!'); 
    this.metadatafieldsTarget.innerHTML = ""; 
    let jsonData = this.hiddenTarget.value; 
    let form_html = this.templateTarget.innerHTML;     
    if(jsonData){ 
      let data = JSON.parse(`${jsonData}`); 
      for (let i = 0; i < data.length; i++){
        this.metadatafieldsTarget.insertAdjacentHTML( 'beforeend', form_html);
        let input_elms = this.metadatafieldsTarget.querySelectorAll("input, select");
        let field_data = data[i];
        for (let j = (i * 3); j < input_elms.length; j+=3){
          input_elms[j].value = field_data['schema'];
          input_elms[j+1].value = field_data['identifier']; 
          input_elms[j+2].value = field_data['qualifier'];
        }
      }
    } else { 
      this.metadatafieldsTarget.insertAdjacentHTML( 'beforeend', form_html);
    }
  }
}