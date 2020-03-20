import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ["choiceHtml", "defaultChoice", "defaultChoiceBtn", "container", "template", "toggle", "manual", "linkedForms", "formChoice", "fieldChoice", 'choiceArray']

  // create_form_field_options(e)
  // ------------------------------------------------------------
  // this toggles between metadata forms and manual choice values
  // @author: David J. Davis
  create_form_field_options(e){
    // get the value then create a fetch option
    let form_id = e.target.value; 
    let field_select = this.fieldChoiceTarget; 
    // let id = 2; 
    let url = `/api/v1/form/${form_id}/fields`;
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
        field_select.add(
        new Option(option.name, option.label, false));
      });
    })
    .catch(function(error) {
      console.log('Error with the API, please contact developers.'); 
    });
  }
  // toggle_choices(e)
  // ------------------------------------------------------------
  // this toggles between metadata forms and manual choice values
  // @author: David J. Davis
  toggle_choices(e){ 
    let val = this.toggleTarget.value;
    if(val == 'manual'){ 
      this.manualTarget.classList.add('d-block');
      this.linkedFormsTarget.classList.remove('d-block');
    } else { 
      this.manualTarget.classList.remove('d-block');
      this.linkedFormsTarget.classList.add('d-block');
    }
  }

  // modify_default_value(e)
  // ------------------------------------------------------------
  // event based function that adjustes the hidden fields default value
  // based on the keyup event.
  // @author: David J. Davis
  modify_default_value(e){ 
    if (e.target.classList.contains('activeDefaultChoice')){
      let defaultVal = e.target.value; 
      this.defaultChoiceTarget.value  = defaultVal; 
    }
  }

  // default_choice(e)
  // ------------------------------------------------------------
  // event based function that uses the click even to determine the
  // default value of the hidden field and visually adjusts to show user
  // which is the default choice.
  // @author: David J. Davis
  default_choice(e){ 
    e.preventDefault();
    let btn = e.target.closest('button'); 
    let buttons = document.querySelectorAll('.defaultChoiceButtons'); 
    let defaultInput = e.target.closest('.input-group').querySelector('input');
    if(btn.classList.contains('activeDefaultChoice')){ 
      btn.classList.remove('btn-success');
      btn.classList.add('btn-dark');
      btn.classList.remove('activeDefaultChoice');
      btn.closest('.input-group').querySelector('input').classList.remove('activeDefaultChoice'); 
      this.defaultChoiceTarget.value  = null; 
    } else { 
      // Clear all DefaultChoice Class Lists 
      for (let i = 0; i < buttons.length; i++) {
        let elm = buttons[i];
        elm.classList.remove('btn-success');
        elm.classList.add('btn-dark');
        elm.classList.remove('activeDefaultChoice');
        elm.closest('.input-group').querySelector('input').classList.remove('activeDefaultChoice'); 
      }
      
      // Toggle Button and Active State
      btn.classList.toggle('btn-dark');
      btn.classList.toggle('btn-success');
      btn.classList.toggle('activeDefaultChoice');

      // Replace DefaultValue string in Hidden Field
      defaultInput.classList.add('activeDefaultChoice'); 
      let defaultVal = defaultInput.value
      this.defaultChoiceTarget.value  = defaultVal; 
    }
  }

  // add_choice(e)
  // ------------------------------------------------------------
  // prevents the buttons default action and adds a new choice item
  // based on the HTML created in a hidden div element by rails.
  // @author: David J. Davis
  add_choice(e){
    e.preventDefault(); 
    let html = this.templateTarget.innerHTML;
    this.containerTarget.insertAdjacentHTML( 'beforeend', html);
  }

  // remove_choice(e)
  // ------------------------------------------------------------
  // event based function that removes the parent input group if there 
  // is more than 1.  There must be 1 so that the choices are still viable. 
  // Also will change the default choice value to an empty value if the input 
  // is the current default choice.
  // @author: David J. Davis
  remove_choice(e){ 
    e.preventDefault();
    if(this.containerTarget.childElementCount > 1) { 
      e.target.closest('div.input-group').remove();
      let closestInput = e.target.closest('.input-group').querySelector('input');
      if (closestInput.classList.contains('activeDefaultChoice')){
        this.defaultChoiceTarget.value  = ''; 
      }
    }
  }

  // reprocess
  // -------------------------------------------------------------
  // this is fired when a field is clicked on to update, or when it is created.
  // this should be fired so that the proper amount of fields show up for the number of options
  // available. 
  // @author: David J. Davis
  reprocess(e){
    e.preventDefault();
    let choices = this.choiceArrayTarget.value.split(',');
    let html = this.templateTarget.innerHTML;
    this.containerTarget.innerHTML = "";
    for (let i = 0; i < choices.length; i++){
      // insert html
      this.containerTarget.insertAdjacentHTML( 'beforeend', html);
      // adjust input elements 
      let input_elms = this.containerTarget.querySelectorAll("input");
      input_elms[i].value = choices[i]; 

      if (this.defaultChoiceTarget.value == choices[i]){ 
        let buttons = this.containerTarget.querySelectorAll(".defaultChoiceButtons");
        buttons[i].classList.remove('btn-dark');
        buttons[i].classList.add('btn-success'); 
        buttons[i].classList.add('activeDefaultChoice');
      }
    }
  }
  
  // create_choice_array
  // -------------------------------------------------------------
  // create the array from choices and save it
  // to the hidden field
  // @author: David J. Davis
  create_choice_array(e){ 
    e.preventDefault();
    let choices = this.containerTarget.querySelectorAll('input'); 
    let choiceArray = []; 
    for (let i = 0; i < choices.length; i++){
      choiceArray.push(choices[i].value); 
    }
    this.choiceArrayTarget.value = choiceArray; 
  }
}