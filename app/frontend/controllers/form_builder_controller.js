import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // targets
  static targets = ['fieldSettingsForm', 'textTemplate', 'idnoTemplate', 'formPreview']

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
    this.fieldSettingsDisplay(fieldInfo); 
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
      html = html.replace(regEx, objs[key]);
    });
    return html;
  }

  // fieldSettingsDisplay(type, state)
  // -------------------------------------------------------------
  // type and state of field settings that need to be displayed.  
  // @author: David J. Davis
  fieldSettingsDisplay({id, json, type}){
    this.resetFieldSettingDisplays(); // reset DOM
    this.commonFieldsDisplay('block'); // show common form fields 
    this.typeFieldsDisplay(type, 'block'); // show type specific fields
    this.click(document.querySelector('.fieldSettingsBtn')); // show field settings 
    this.populateForm(id, json); // Loop over JSON Data & Insert into form
  }

  // fieldSettingsDisplay(type, state)
  // -------------------------------------------------------------
  // type and state of field settings that need to be displayed.  
  // @author: David J. Davis
  populateForm(id, json){
    let data = JSON.parse(json);
    let form = this.fieldSettingsFormTarget; 
    Object.keys(data).forEach(function(key) {    
      let input = form.querySelector('[name='+key+']');  
      if(key == 'position' || input == undefined || input == null){ return; };

      if(input.type == 'checkbox' || input.type == 'radio'){ 
        input.checked = data[key]; 
      } else { 
        input.value = data[key]; 
      }
    }); 
  }

  // typeFieldsDisplay(type, state)
  // -------------------------------------------------------------
  // display or hide the common fields 
  // @author: David J. Davis
  typeFieldsDisplay(type, state){ 
    let typeClass = '.' + type.toLowerCase() + 'FieldSettings'; 
    let typeFields = document.querySelectorAll(typeClass);
    for (let i = 0; i < typeFields.length; i++) {
      typeFields[i].style.display = state;
    }
  }

  // commonFieldsDisplay(state)
  // -------------------------------------------------------------
  // display or hide the common fields 
  // @author: David J. Davis
  commonFieldsDisplay(state){ 
    let commonFields = document.querySelectorAll('.commonFieldSettings'); 
    for (let i = 0; i < commonFields.length; i++) {
      commonFields[i].style.display = state;
    }
  }

  // resetFieldSettingDisplays()
  // -------------------------------------------------------------
  // determining how to display and hide all elements.  
  // @author: David J. Davis
  resetFieldSettingDisplays(){ 
    let fieldsets = document.querySelectorAll('#fieldSettings > form > fieldset');
    for (let i = 0; i < fieldsets.length; i++) {
      fieldsets[i].style.display = 'none';
    }
  }

  // saveChanges(e)
  // -------------------------------------------------------------
  // gather and save all fields and idnos into the proper place.
  // @author: David J. Davis
  saveChanges(e) { 
    //console.log('save changes triggered!');
  }

  // click
  // -------------------------------------------------------------
  // Simulate a click event.
  // @param {Element} elem  the element to simulate a click on
    // @author: David J. Davis
  click(elem){ 
    let evt = new MouseEvent('click', {
      bubbles: true,
      cancelable: true,
      view: window
    });
    let canceled = !elem.dispatchEvent(evt);
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