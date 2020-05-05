import {Controller} from "stimulus";
let debounce = require('lodash/debounce');

export default class AllowedExtensions extends Controller {
  // sets stimulus controller to have the proper targets
  static targets = ['container', 'template', 'fileTypes']


  // initialize
  // -------------------------------------------------------------
  // creates a debounce effect on initialization
  // this debounce effect comes from lodash and plays an important role 
  // it will not allow this function to be called until 1 second has elapsed
  // between calls.  
  // @author: David J. Davis
  initialize(){
    this.create_allowed_extensions = debounce(this.create_allowed_extensions, 1000).bind(this)
  }

  // connect
  // This happesn on the load of the document
  // --------------------------------------------------------------
  connect() { 
    let elm = document.getElementById('ext_{{id}}');
    let id = this.generateFieldID(); 
    elm.id = `ext_${id}`
  }

  // add
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  add(e) {
    e.preventDefault();
    let id = this.generateFieldID(); 
    let html = this.templateTarget.innerHTML.replace('{{id}}', id);
    this.containerTarget.insertAdjacentHTML( 'beforeend', html);
  }

  // remove
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  remove(e) {
    e.preventDefault();  
    if(this.containerTarget.childElementCount > 1) { 
      e.target.closest('div.allowed-extensions-group').remove();
    }
  }

  // create allowed extensions
  // -------------------------------------------------------------
  // grabs html from a rendered data component and adds to the DOM
  // @author: David J. Davis
  create_allowed_extensions(e){
    this.extension_array();
  }

  // reprocess
  // -------------------------------------------------------------
  // this is fired when a field is clicked on to update, or when it is created.
  // this should be fired so that the proper amount of fields show up for the number of options
  // available. 
  // @author: David J. Davis
  reprocess(e){
    e.preventDefault();
    let ext = this.fileTypesTarget.value.split(',');
    let html = this.templateTarget.innerHTML;
    this.containerTarget.innerHTML = "";
    for (let i = 0; i < ext.length; i++){
      // insert html
      let id = this.generateFieldID(); 
      html = html.replace('{{id}}', id);
      this.containerTarget.insertAdjacentHTML( 'beforeend', html);
      // adjust input elements 
      let input_elms = this.containerTarget.querySelectorAll("input");
      input_elms[i].value = ext[i]; 
    }
  }

  // Generates a mirosecond time
  // -------------------------------------------------------------
  // renders an extensions array to put in a hidden field
  // @author: David J. Davis
  generateFieldID(){
    return window.performance.now().toString().replace('.', '')
  }

  // create allowed extensions
  // -------------------------------------------------------------
  // renders an extensions array to put in a hidden field
  // @author: David J. Davis
  extension_array(){ 
    let extensions = this.containerTarget.querySelectorAll('input'); 
    let extensionArray = []; 
    for (let i = 0; i < extensions.length; i++){
      extensionArray.push(extensions[i].value); 
    }
    this.fileTypesTarget.value = extensionArray; 
  }
}