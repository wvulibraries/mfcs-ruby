import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // targets
  static targets = ['textTemplate', 'idnoTemplate', 'formPreview']

  // newField(e)
  // -------------------------------------------------------------
  // click event
  // This sets the field info form the addFields action. 
  // Creates a new preview element, and sets JSON, Sort, and other important
  // information into the HTML of the preview for use later.
  // Uses other functions to generate the information needed. 
  // @author: David J. Davis
  newField(e) { 
    // prevent default action 
    e.preventDefault();

    // use html data to get some information 
    let fieldInfo = { 
      'json': e.target.dataset.json, 
      'id': this.generateFieldID(), 
      'sort': this.sortOrder(), 
      'type': e.target.dataset.type, 
      'template': this.targets.find(e.target.dataset.template).innerHTML
    };

    // sets html the initial preview
    let previewHTML = this.preview(fieldInfo);
    this.formPreviewTarget.insertAdjacentHTML( 'beforeend', previewHTML );
  }

  // editField(e)
  // -------------------------------------------------------------
  // click event
  // This sets the form elements, previews, and templates for editing the
  // field.  If another field is clicked or any element of the page exits the 
  // settings field, then the elements should be saved in the hidden field in form settings.
  // @author: David J. Davis
  editField(e) { 
    e.preventDefault; 
    console.log('Edit Field Fired');
  }

  // removeField(e)
  // -------------------------------------------------------------
  // click event
  // this removes the field from the preview, which effectively removes it
  // from the final submission 
  // @author: David J. Davis
  removeField(e) { 
    e.preventDefault;
    let elmsToRemove = document.getElementsByClassName(e.target.dataset.id);
    while (elmsToRemove[0]){ 
      elmsToRemove[0].parentNode.removeChild(elmsToRemove[0]);
    }  
  }

  submit(e) { 
    e.preventDefault; 
  }

  // generateFieldID()
  // -------------------------------------------------------------
  // Uses window performance which generates a date time stamp plus microseconds. 
  // The microseconds period is removed and that is the unique ID.  
  // @author: David J. Davis 
  generateFieldID(){
    return window.performance.now().toString().replace('.', '')
  }

  // sortOrder()
  // -------------------------------------------------------------
  // this counts the number of children inside of the parent div to see the number of fields and create a sort order for new elements
  // Might be added to later. 
  // @author: David J. Davis
  sortOrder(){ 
    return this.formPreviewTarget.childElementCount;
  }

  // modifyTemplateString()
  // -------------------------------------------------------------
  // replaces template variables with proper values
  // @author: David J. Davis
  modifyTemplateString({id, json, sort, template}){
    let tmpHTML = template.replace(/{{id}}/g, id)
                      .replace(/{{json}}/g, json)
                      .replace(/{{sort}}/g, sort);  
    return tmpHTML; 
  }

  // preview()
  // -------------------------------------------------------------
  // Uses other method helpers and JSON to generate a preview of the field.
  // Relies on HTML template having proper {{variables}} declared.
  // The HTML templates will be different for each field and control how much of this works.
  // @author: David J. Davis
  preview({id, json, sort, template}){ 
    let objs = JSON.parse(json); 
    let html = this.modifyTemplateString({"id": id, "json": json, "template": template, "sort": sort}); 
    Object.keys(objs).forEach( function(key) { 
      let regEx = new RegExp('{{'+key+'}}', 'g');

      // TO DO 
      // EACH PREVIEW IS GOING TO HAVE DIFFERENT ELEMENTS THAT NEED TO BE CREATED
      // HTML For ARRAYS / HASHES / ETC MAY BE DIFFERENT
      if(objs[key]) { 
        html = html.replace(regEx, objs[key]);
      }
    });
    return html;
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