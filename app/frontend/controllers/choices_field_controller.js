import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ["choiceHtml", "defaultChoice", "defaultChoiceBtn", "container", "template", "toggle", "manual", "linkedForms"]

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
}