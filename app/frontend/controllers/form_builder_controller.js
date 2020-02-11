import {Controller} from "stimulus";
import Validation from "../components/validation/validation";
import click from "../components/events/click";
import change from "../components/events/change";
import metadata_schema_controller from "./metadata_schema_controller";

export default class extends Controller {
  // targets
  static targets = ['warningMessage', 'fieldSettingsForm', 'textTemplate', 'textareaTemplate', 'idnoTemplate', 'formPreview'];

  // Connect 
  //  Basically Document Read Function
  connect(){
    // this connects the first descision modal
    $("#formTypeModal").modal('show');
  }

  metadataForm(e){ 
    // create a single line item for title  
    this.createTitleField(); 
  }

  objectForm(e){ 
    // create and IDNO Field 
    this.createIDNOField(); 
    this.createTitleField(); 
  }

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
      'json': JSON.parse(e.target.dataset.json), 
      'id': this.generateFieldID(), 
      'sort': this.sortOrder(), 
      'type': e.target.dataset.type, 
      'template': this.targets.find(e.target.dataset.template).innerHTML
    };
    fieldInfo['json'] = this.mergeFieldInfo(fieldInfo); 

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
    e.stopPropagation();
    let tmpJSON = JSON.parse(e.currentTarget.dataset.json.replace(/'/g, '"'));
    let id = e.currentTarget.dataset.id; 
    // use html data to get some information 
    let fieldInfo = { 
      'json': tmpJSON, 
      'id': id,
      'sort': e.currentTarget.dataset.sort,
      'type': e.currentTarget.dataset.fieldtype, 
    };
    fieldInfo['json'] = this.mergeFieldInfo(fieldInfo); 
    // show settings on click
    this.fieldSettingsDisplay(fieldInfo); 
  }

  // removeField(e)
  // -------------------------------------------------------------
  // click event
  // this removes the field from the preview, which effectively removes it
  // from the final submission 
  // @author: David J. Davis
  removeField(e) { 
    e.preventDefault;
    e.stopPropagation();
    let elmsToRemove = document.getElementsByClassName(e.target.dataset.id);
    while (elmsToRemove[0]){ 
      elmsToRemove[0].parentNode.removeChild(elmsToRemove[0]);
    }  
  }

  // popover(e)
  // -------------------------------------------------------------
  // makes the popovers work because bootstrap doesn't work with dynamic data very well. 
  // @author: David J. Davis
  popover(e) { 
    e.preventDefault;
    e.stopPropagation();
    $(e.currentTarget).popover({
      placement: e.currentTarget.dataset.placement,
      html: true,
      content: e.currentTarget.dataset.content 
    });
  }

  // mergeFieldInfo({fieldInfo Params})
  // -------------------------------------------------------------
  // This function prepares the JSON with information gathered from other parts of the interface. 
  // @author: David J. Davis
  mergeFieldInfo({json, id, sort, type}){ 
    json['sort_order'] = sort; 
    json['type'] = type;
    json['field_id'] = id;
    return json;
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

  // sortPreview()
  // -------------------------------------------------------------
  // This function is primarily view related.  It sorts the HTML in a given
  // view based on a data-sort attribute. 
  // @author: David J. Davis
  sortPreview(){ 
    let container = this.formPreviewTarget;
    let elements = Array.from(container.children); 
    let sorted = elements.sort(function(a,b){ 
      return +a.dataset.sort - +b.dataset.sort
    });
    container.innerHTML = '';
    sorted.forEach(elm => container.append(elm));
  }

  // modifyTemplateString()
  // -------------------------------------------------------------
  // replaces template variables with proper values
  // @author: David J. Davis
  modifyTemplateString({id, json, sort, template}){
    let tmpJSON = JSON.stringify(json).replace(/"/g, "'");
    let tmpHTML = template.replace(/{{id}}/g, id)
                      .replace(/{{json}}/g, tmpJSON)
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
    let html = this.modifyTemplateString({"id": id, "json": json, "template": template, "sort": sort});
    Object.keys(json).forEach( function(key) { 
      let regEx = new RegExp('{{'+key+'}}', 'g');
      html = html.replace(regEx, json[key]);
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
    this.populateForm(id, json); // Loop over JSON Data & Insert into form
    this.refreshMetadataFields(); // refresh metadata
  }

  refreshMetadataFields(){ 
    let elm = document.querySelector('.metadata-refresh'); 
    click(elm); 
  }

  // fieldSettingsDisplay(type, state)
  // -------------------------------------------------------------
  // type and state of field settings that need to be displayed.  
  // @author: David J. Davis
  populateForm(id, json){
    let data = json;
    let form = this.fieldSettingsFormTarget; 
    Object.keys(data).forEach(function(key) {    
      let input = form.querySelector('[name='+key+']');  
      if(key == 'position' || input == undefined || input == null){ return; };
      if(input.type == 'checkbox' || input.type == 'radio'){ 
        if(data[key] == 'true'){ 
          input.value = 1;
          input.setAttribute('checked', 'checked');
        } else { 
          input.value = 0;
        }
      } else { 
        input.value = data[key]; 
      }
      change(input);
    }); 
  }

  // fieldSettingsBindings()
  // -------------------------------------------------------------
  // This sets up the bindings each time the form is reset. 
  // @author: David J. Davis
  fieldSettingsBindings(){ 
    document.addEventListener('change keyup', function(e){
      console.log(e.target); 
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
    this.warningMessage('hide');
  }

  // resetFieldSettingDisplays()
  // -------------------------------------------------------------
  // determining how to display and hide all elements.  
  // @author: David J. Davis
  resetFieldSettingDisplays(){ 
    this.clearForm(this.fieldSettingsFormTarget); // clear form
    let fieldsets = document.querySelectorAll('#fieldSettings > form > fieldset');
    for (let i = 0; i < fieldsets.length; i++) {
      fieldsets[i].style.display = 'none';
    }
    this.warningMessage('show');
  } 

  // warningMessage(status)
  // -------------------------------------------------------------
  // toggles dipslay of a warning message about field selection  
  // @param: status (show --> display='block') || (hide or anyother string --> display='none')
  // @author: David J. Davis
  warningMessage(status){
    if(status == 'show'){ 
      this.warningMessageTarget.style.display = 'block';
    } else { 
      this.warningMessageTarget.style.display = 'none';
    }
  }

  // saveFieldSettings(e)
  // -------------------------------------------------------------
  // Saves the field settings into the elements json
  // @author: David J. Davis
  saveFieldSettings(e) { 
    e.preventDefault();
    // let formData = new FormData(this.fieldSettingsFormTarget)
    var data = {};
    let form_elements = this.fieldSettingsFormTarget.elements;
    for (let i = 0; i < form_elements.length; i++){
      let field_type = form_elements[i].type.toLowerCase();
      let field_name = form_elements[i].name; 
      let field_value = form_elements[i].value;
      let skip_fields = ['utf8', 'authenticity_token'];
      let input_fields = ["text", "password", "textarea", "url", "number", "email", "tel", "hidden", "date", "datetime-local", "month", "range", "time", "week", "radio", "checkbox", "select-one", "select-multi"]; 

      if(skip_fields.includes(field_name) || !input_fields.includes(field_type)) {  
        continue;
      }
      
      // only look for the following elements 
      data[field_name] = field_value; 
    }

    // replace element with a new one 
    let id = data['field_id'];
    if(id) { 
      let template = `${data['type']}Template`;
      let fieldInfo = { 
        'json': data, 
        'id': id,
        'sort': data['sort_order'],
        'type': data['type'],
        'template': this.targets.find(template).innerHTML
      };
      let elmToRemove = document.getElementsByClassName(id);
      let previewHTML = this.preview(fieldInfo);
      elmToRemove[0].parentNode.removeChild(elmToRemove[0]); 
      this.formPreviewTarget.insertAdjacentHTML( 'beforeend', previewHTML );
      this.sortPreview(); 
    } else { 
      console.log('nothing to save moving on'); 
    }
  }

  // clearForm(formElm)
  // -------------------------------------------------------------
  // Resets the form Element that is passed into the form clearing.
  // @param {Element} the form element or target
  // @return ABSTRACT VIEW ONLY
  // @author: David J. Davis
  clearForm(formElm){ 
    let form_elements = formElm.elements;
    for (let i = 0; i < form_elements.length; i++){
      let field_type = form_elements[i].type.toLowerCase();
      switch (field_type) {
        case "text":
        case "password":
        case "textarea":
        case "url":
        case "number":
        case "hidden":
          form_elements[i].value = "";
          break;
        case "radio":
        case "checkbox":
          if(form_elements[i].checked){ 
            form_elements[i].checked = false;
            form_elements[i].removeAttribute('checked');
          }
          break;
        case "select-one":
        case "select-multi":
          form_elements[i].selectedIndex = -1;
          break;
        default:
          break;
      }
    }
  }

  // createTitleField()
  // -------------------------------------------------------------
  // Title field for Metadata or Object forms. 
  // @author: David J. Davis
  createTitleField() { 
    let titleJSON = {
      "name": "title",
      "type": "text",
      "label": "Title",
      "value": "",
      "placeholder": "",
      "id": "title",
      "class": "",
      "style": "",
      "help_type": "",
      "required": "true",
      "duplicates": "false",
      "readonly": "false",
      "disabled": "false",
      "disabled_insert": "false",
      "disabled_update": "false",
      "public_release": "true",
      "oai_release": "",
      "sortable": "true",
      "searchable": "true",
      "display_table": "true",
      "hidden": "",
      "validation": "",
      "validation_regex": "",
      "access": "",
      "fieldset": "",
      "metadata_standard": " : ",
      "help": "",
      "min": "",
      "max": "",
      "step": "",
      "format": "characters"
    }; 
    // use html data to get some information 
    let fieldInfo = { 
      'json': titleJSON, 
      'id': this.generateFieldID(), 
      'sort': this.sortOrder(), 
      'type': 'text', 
      'template': this.textTemplateTarget.innerHTML
    };
    console.log(fieldInfo); 
    fieldInfo['json'] = this.mergeFieldInfo(fieldInfo); 

    // sets html the initial preview
    let previewHTML = this.preview(fieldInfo);
    this.formPreviewTarget.insertAdjacentHTML( 'beforeend', previewHTML );
    this.fieldSettingsDisplay(fieldInfo); 
  }

  // createIDNOField()
  // -------------------------------------------------------------
  // Creates an IDNO field on the fly.
  // @author: David J. Davis
  createIDNOField() { 
    let idnoJSON = {
      "name": "idno",
      "position": "",
      "type": "idno",
      "label": "Identifier",
      "value": "",
      "placeholder": "",
      "id": "idno",
      "class": "",
      "style": "",
      "required": "true",
      "duplicates": "true",
      "read_only": "false",
      "disabled": "false",
      "disabled_on_insert": "false",
      "disabled_on_update": "false",
      "public_release": "true",
      "oai_release": "true",
      "sortable": "true",
      "searchable": "true",
      "display_in_list": "true",
      "hidden": "",
      "validation": "",
      "validation_regex": "",
      "metadata_standards": [],
      "help_type": "",
      "help": "",
      "managed_by": "user",
      "idno_format": "",
      "start_increment": "1"
    }; 

    // use html data to get some information 
    let fieldInfo = { 
      'json': idnoJSON, 
      'id': this.generateFieldID(), 
      'sort': this.sortOrder(), 
      'type': 'idno', 
      'template': this.idnoTemplateTarget.innerHTML
    };
    console.log(fieldInfo); 
    fieldInfo['json'] = this.mergeFieldInfo(fieldInfo); 

    // sets html the initial preview
    let previewHTML = this.preview(fieldInfo);
    this.formPreviewTarget.insertAdjacentHTML( 'beforeend', previewHTML );
    this.fieldSettingsDisplay(fieldInfo); 
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