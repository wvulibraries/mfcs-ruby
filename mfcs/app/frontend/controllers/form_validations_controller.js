import {Controller} from "stimulus";
import Validation from "../components/validation/validation";
let debounce = require('lodash/debounce');

export default class FormValidations extends Controller {
  static targets = [ "formId" ]

  // initialize
  // -------------------------------------------------------------
  // creates a debounce effect on initialization
  // this debounce effect comes from lodash and plays an important role 
  // it will not allow this function to be called until 1 second has elapsed
  // between calls.  
  // @author: David J. Davis
  initialize(){
    this.validate = debounce(this.validate, 100).bind(this);
  }

  // validateField
  // -------------------------------------------------------------
  // creates a debounce effect on initialization
  // this debounce effect comes from lodash and plays an important role 
  // it will not allow this function to be called until 1 second has elapsed
  // between calls.  
  // @author: David J. Davis
  validate(e){ 

    // Setup the URL with the params
    const params = new URLSearchParams({
      form_id: this.formIdTarget.value.trim(),
      fieldname: e.target.getAttribute("data-name").trim(),
      input: e.target.value.trim()
    });

    let url = '/api/v1/validate?' + params.toString();

    // Perform the Fetch Request
    // Sets the Headers for the API_KEYS
    fetch(url, {
      method: "GET",
      headers: {
        "api_key": "something",
        "Content-Type": "application/json", 
      }
    })
    .then(resp => resp.json())
    .then(data => {
      let validation_target = e.target; 
      let validation_result = data.status;
      let validation_message = data.errors.join(' ');
      let feedbackElm = validation_target.parentNode.querySelector('.feedback');
      feedbackElm.innerHTML = validation_message;
      
      if(validation_result == true){ 
        validation_target.classList.remove('is-invalid');
        feedbackElm.classList.remove('invalid-feedback');
      } else { 
        validation_target.classList.add('is-invalid');
        feedbackElm.classList.add('invalid-feedback');
      }
    })
    .catch(error => {
      console.error(error); 
      console.error('Error with the API, please contact developers.'); 
    });
  }

  // allowedFileTypes(e)
  // -------------------------------------------------------------
  // Any time the file field is changed check the file types to
  // ensure that a file is not being uploaded that is not allowed.
  // between calls.  
  // @author: David J. Davis
  allowedFileTypes(e){ 
    let allowedFiles = e.target.dataset.allowedFileTypes.split(','); 
    let files = e.target.files;
    let feedbackElm = e.target.parentNode.querySelector('.feedback');

    let errors = []
    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      let name = file.name; 
      let fileExt = name.split('.').pop();
      let type = file.type.split('/').pop(); 

      if(allowedFiles.includes(fileExt) || allowedFiles.includes(type)){ 
        console.log('valid file');
      } else { 
        errors.push(name); 
      }
    }

    if(errors.length){ 
      e.target.classList.add('is-invalid');
      feedbackElm.classList.add('invalid-feedback');
      let feedbackStr = 'The following files are not valid types: ';
          feedbackStr += errors.join(','); 
          feedbackStr += '. Please add the correct file types or modify the forms allowed file types.'; 
      feedbackElm.innerHTML = feedbackStr; 
      document.querySelector('input[type="submit"]').setAttribute('disabled', 'disabled')
    } else { 
      e.target.classList.remove('is-invalid');
      feedbackElm.classList.remove('invalid-feedback');
      feedbackElm.innerHTML = '';
      document.querySelector('input[type="submit"]').removeAttribute('disabled', 'disabled')
    }
  }
}