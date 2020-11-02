import {Controller} from "stimulus";
import Validation from "../components/validation/validation";
import click from "../components/events/click";
import change from "../components/events/change";
import PurgeKeys from "../components/form_builder/purge_keys";


export default class extends Controller {
  // =============================================================
  // Controller Constructors 
  // =============================================================
  
  // targets
  static targets = ['formSettings', 'addFields', 'fieldSettings', 'warningMessage', 'fieldSettingsForm', 'textTemplate', 'textareaTemplate', 'idnoTemplate', 'formPreview', 'panes', 'fieldSettingsJSON'];

  // Connect 
  //  Basically Document Read Function
  connect(){
    // this connects the first descision modal
    if(this.fieldSettingsJSONTarget.value == null || this.fieldSettingsJSONTarget.value == undefined || this.fieldSettingsJSONTarget.value == ''  || this.fieldSettingsJSONTarget.value.length < 1){ 
      $("#formTypeModal").modal('show'); // gross icky bootstrap modal
    } else { 
      // this means the form is an edit, or an errored form
      // display the form preview
      // console.dir(JSON.parse(this.fieldSettingsJSONTarget.value));

      let currentFields = JSON.parse(this.fieldSettingsJSONTarget.value); 

      for (let index = 0; index < currentFields.length; index++) {
        // field JSON
        const field = currentFields[index];
        // use field data to get and set information
        let type = field["type"]; 
        let template = field["type"] + 'Template';
        let fieldInfo = { 
          'json': field, 
          'id': field['field_id'], 
          'sort': field['sort_order'], 
          'type': type, 
          'template': this.targets.find(template).innerHTML
        };

        // sets html the initial preview
        let previewHTML = this.preview(fieldInfo);
        this.formPreviewTarget.insertAdjacentHTML( 'beforeend', previewHTML );
      }
    }
  }

  // =============================================================
  // EVENTS BASED METHODS
  // =============================================================

  // saveSubmit(e)
  // -------------------------------------------------------------
  // click event
  // Handles the actual form submission of the object.
  // @author: David J. Davis
  saveSubmit(event) {
    event.preventDefault(); 
    this.saveFieldSettings(event); 
    this.gatherFieldData();
    this.formSettingsTarget.querySelector('form').submit(); 
  }

  // editField(e)
  // -------------------------------------------------------------
  // click event
  // This sets the form elements, previews, and templates for editing the
  // field.  If another field is clicked or any element of the page exits the 
  // settings field, then the elements should be saved in the hidden field in form settings.
  // @author: David J. Davis
  editField(e) { 
    // prevention of bubbling and default
    e.preventDefault(); 
    e.stopPropagation();

    // resets 
    this.saveFieldSettings(event); 
    
    // panes 
    this.interfacePanes();
    e.currentTarget.classList.add('active');

    // datasets
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

  // addFieldPane(e)
  // -------------------------------------------------------------
  // click event logic tied to the menu items
  // triggers a clear, save, and adjusts menu state
  // @author: David J. Davis
  addFieldPane(e) {
    e.preventDefault(); 
    this.clearInterfacePanes(); 
    this.saveFieldSettings(event); 
    
    e.currentTarget.classList.add('active');
    this.addFieldsTarget.classList.add('show'); 
  }

  // fieldSettingsPane(e)
  // -------------------------------------------------------------
  // click event logic tied to the menu items
  // triggers a clear, save, and adjusts menu state
  // @author: David J. Davis
  fieldSettingsPane(e) {
    e.preventDefault(); 
    this.clearInterfacePanes(); 
    this.saveFieldSettings(event); 

    e.currentTarget.classList.add('active');
    this.fieldSettingsTarget.classList.add('show');
  }

  // formSettingsPane(e)
  // -------------------------------------------------------------
  // click event logic tied to the menu items
  // triggers a clear, save, and adjusts menu state
  // @author: David J. Davis
  formSettingsPane(e) {
    e.preventDefault(); 
    this.clearInterfacePanes(); 
    this.saveFieldSettings(event); 
    
    e.currentTarget.classList.add('active');
    this.formSettingsTarget.classList.add('show'); 
  }

  // metadataForm(e)
  // -------------------------------------------------------------
  // click event
  // Sets up a metadata field using appropriate fields.
  // @author: David J. Davis
  metadataForm(e){ 
    let metadata_field = document.querySelector('#form_metadata');
    metadata_field.value = true;  
    // create a single line item for title  
    this.createTitleField(); 
  }

  // objectForm(e)
  // -------------------------------------------------------------
  // click event
  // Sets up an object form using the appropriate fields.
  // @author: David J. Davis
  objectForm(e){ 
    let metadata_field = document.querySelector('#form_metadata');
    metadata_field.value = false;  
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

    // clear the interface panes 
    // set the field settings form
    this.interfacePanes();
    this.fieldSettingsDisplay(fieldInfo); 

    // set new element to active
    let newElm = document.querySelector(`[data-id='${fieldInfo['id']}']`);
    newElm.classList.add('active');
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

  // removeField(e)
  // -------------------------------------------------------------
  // click event
  // this removes the field from the preview, which effectively removes it
  // from the final submission 
  // @author: David J. Davis
  removeField(e) { 
    e.preventDefault;
    e.stopPropagation();

    // reset interfaces and save them in the current state
    this.saveFieldSettings(event); 

    // delete the stuff 
    let elmsToRemove = document.getElementsByClassName(e.target.dataset.id);
    while (elmsToRemove[0]){ 
      elmsToRemove[0].parentNode.removeChild(elmsToRemove[0]);
    }  
  }

  // saveFieldSettings(e)
  // -------------------------------------------------------------
  // Saves the field settings into the elements json
  // @author: David J. Davis
  saveFieldSettings(e) { 
    e.preventDefault();
    console.log('save settings triggered');

    // save data to json
    var data = {};
    let form_elements = this.fieldSettingsFormTarget.elements;
    for (let i = 0; i < form_elements.length; i++){
      let field_type = form_elements[i].type.toLowerCase();
      let field_name = form_elements[i].name; 
      let field_value = form_elements[i].value;
      let skip_fields = ['utf8', 'authenticity_token'];
      let input_fields = ["text", "password", "textarea", "color", "url", "number", "email", "tel", "hidden", "date", "datetime-local", "month", "range", "time", "week", "radio", "checkbox", "select-one", "select-multi"]; 

      if(skip_fields.includes(field_name) || !input_fields.includes(field_type)) {  
        continue;
      }

      // only look for the following elements 
      if(field_type == 'checkbox' || field_type == 'radio'){ 
        let field_checked = form_elements[i].checked;
        if(field_checked) { 
          data[field_name] = true
        } else { 
          data[field_name] = false
        }
      } else {
        data[field_name] = field_value;
      } 
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

      // resets
      this.clearActiveFormPreview();
      this.resetFieldSettingDisplays();
    }
  }

  // =============================================================
  // METHODS WITH RETURN
  // =============================================================

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
    return this.formPreviewTarget.childElementCount + 1;
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

  // =============================================================
  // DOM BASED METHODS
  // =============================================================

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

    // types specific refreshes 
    if(type == 'select' || 'multiselect' || 'choice') { 
      this.refreshChoiceFields(); // refresh choices
    }
    
    if(type == 'file' || type == 'fileUpload') { 
      this.refreshFileTypes();  // refresh file types
    }
  }

  // refreshMetadataFields
  // -------------------------------------------------------------
  // triggers a click on a hidden button this click causes an event
  // in the metadata controller to fire
  // done to be a seperation of concerns for metadata objects  
  // @author: David J. Davis
  refreshMetadataFields(){ 
    let elm = document.querySelector('.metadata-refresh'); 
    click(elm); 
  }

  // refreshChoiceFields
  // -------------------------------------------------------------
  // Trigger choice fields to refresh.
  // @author: David J. Davis
  refreshChoiceFields(){ 
    let elm = document.querySelector('.choices-refresh'); 
    click(elm); 
  }

  // refreshFileTypes
  // -------------------------------------------------------------
  // Trigger refresh on file types for allowed file types. 
  // Done by clicking an invisible button to trigger another function from another controller.
  // @author: David J. Davis
  refreshFileTypes(){ 
    let elm = document.querySelector('.file-types-refresh'); 
    click(elm); 
  }

  // populateForm(id, json)
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
        if(data[key] == 'true' || data[key] == 1){ 
          input.checked = true; 
        } else { 
          input.checked = false; 
        }
      } else { 
        input.value = data[key]; 
      }
      // this determines if an event change needs fired
      let change_event_elms = ['help', 'help_type','managed_by', 'choice_type', 'choice_form_field', 'choice_form','convert_video', 'video_thumbnail', 'convert_audio', 'border', 'watermark', 'thumbnail', 'convert', 'border_color']
      if (change_event_elms.includes(key)){
        change(input);
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
    this.warningMessage('hide');
  }

  // resetFieldSettingDisplays()
  // -------------------------------------------------------------
  // determining how to display and hide all elements.  
  // @author: David J. Davis
  resetFieldSettingDisplays(){ 
    this.clearForm(this.fieldSettingsFormTarget); // clear form
    let fieldsets = document.querySelectorAll('#fieldSettings > form fieldset');
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
        case "select":
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
      "managed_by": "User",
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

    fieldInfo['json'] = this.mergeFieldInfo(fieldInfo); 

    // sets html the initial preview
    let previewHTML = this.preview(fieldInfo);
    this.formPreviewTarget.insertAdjacentHTML( 'beforeend', previewHTML );
    this.fieldSettingsDisplay(fieldInfo); 
  }

  // interfacePanes()
  // -------------------------------------------------------------
  // This calls clear interface panes which removes all formatting and styles
  // from the panes and hides them.  Thenshows the filed settings and
  // makes that button active. 
  // @author: David J. Davis
  interfacePanes(){ 
    this.clearInterfacePanes();
    // then set active class for fieldSettingsPane
    this.fieldSettingsTarget.classList.add('show'); 
    document.querySelector('.fieldSettingsBtn').classList.add('active'); 
  }

  // clearInterfacePanes()
  // -------------------------------------------------------------
  // Loops through all the button elements and removes active classes.
  // Then removes active/show classes on the panes.
  // @author: David J. Davis
  clearInterfacePanes(){ 
    let panes = this.panesTarget.querySelectorAll('button');
    [].forEach.call(panes, function(el) {
      el.classList.remove("active");
    });
    // clear panes
    this.formSettingsTarget.classList.remove('show'); 
    this.addFieldsTarget.classList.remove('show'); 
    this.fieldSettingsTarget.classList.remove('show');
  }

  // clearActiveFormPreview()
  // -------------------------------------------------------------
  // Loops through all the field previews and removes the active class.
  // active class shows which one is being edited.
  // @author: David J. Davis
  clearActiveFormPreview(){ 
    let previews = document.querySelectorAll('.field-preview'); 
    [].forEach.call(previews, function(el) {
      el.classList.remove("active");
    });
  }

  // gatherFieldData()
  // -------------------------------------------------------------
  // Gets all the form data json that has been created so far and applies it to a
  // concatenated json object inside of the form as a hidden field.  
  // @author: David J. Davis
  gatherFieldData(){
    let data = this.formPreviewTarget.querySelectorAll('.field-preview');
    let obj = []; 

    [].forEach.call(data, function(el) {
      let json = JSON.parse(el.dataset.json.replace(/'/g, '"'));
      let purge = new PurgeKeys(json['type'], json);
      let cleaned_json = purge.delete_keys(); 
      obj.push(cleaned_json);
    });

    this.fieldSettingsJSONTarget.value = JSON.stringify(obj); 
  }
}