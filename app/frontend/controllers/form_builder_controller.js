import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // targets
  static targets = ['textTemplate', 'idnoTemplate', 'formPreview']

  newField(e) { 
    // prevent default action 
    e.preventDefault();

    // get json 
    let templateJSON = JSON.parse(e.target.dataset.json);
    let id = this.generateFieldID(); 
    let previewTemplate = this.targets.find(e.target.dataset.template)
    
    console.log(id);
    console.log(previewTemplate); 
    // console.log(templateJSON);
    // console.log('New Field Fired');
  }

  editField(e) { 
    e.preventDefault; 
    console.log('Edit Field Fired');
  }

  removeField(e) { 
    e.preventDefault; 
    console.log('Remove Event Fired'); 
  }

  submit(e) { 
    e.preventDefault; 
  }

  generateFieldID(){ 
    return this.formPreviewTarget.childElementCount;
  }


  //save(){}
  //delete(){}
  //form(){}
  //edit(){}
  //preview(){}
  //modfiyPreview(){}
  //validation(){}
  //type(){}
}