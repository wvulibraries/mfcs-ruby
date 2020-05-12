import {Controller} from "stimulus";
import click from "../components/events/click";

export default class extends Controller {
  // stimulus targets
  static targets = ['sortContainer']; 
  
  /**
   * Connects the controller to the DOM
  */
  connect() { 
    // console.log(domElms); 
    this.grabbedElm = null; 
    this.elms = null; 
    this.container = this.sortContainerTarget; 
    this.sortElmClass = '.field-preview'; 
  }

  // ========================================================================
  // SETTERS
  // ========================================================================

  /**
   * When the mouse goes down we want to register the element
   * that is being dragged as well as make sure the element has a
   * dragging class.
   * @param {targetElm} the element that is being dragged.
  */
  setGrabbed(targetElm){
    targetElm.classList.add('dragging'); 
    this.grabbedElm = targetElm; 
  }

  /**
   * unset all elements after the drag event completes
  */
  unsetGrabbed(){ 
    this.grabbedElm.classList.remove('dragging'); 
    this.grabbedElm = null;  
  }

  /**
   * Set the elms nodelist on the start of the drag to speed the interaction up.
   * Relies on this.container and this.elmClass
  */
  setElmList(){ 
    this.elms = this.container.querySelectorAll(this.sortElmClass); 
  }

  /**
   * unset the list so that prevention items happen.
  */
  unsetElmList(){
    this.elms = null; 
  }

  // ========================================================================
  // GETTERS
  // ========================================================================

  /**
   * getIndexOfElm grabs the elements index as it currently sits in the DOM. 
   * @param {elm} the element that is being dragged.
   * @author David J. Davis
  */
  getIndexOfElm(elm, elms) { 
    let arr = Array.from(elms); 
    return arr.indexOf(elm);
  }

  /**
   * Detects if the item is a class and has proper indexing to see if it is a sibling.
   * Used in the collision of objects to prevent children from becoming the target.
   * @param {targetElm} the element that is being tested.
   * @param {siblingClassName} the class name of the group of siblings make sure they are all the same.
   * @author David J. Davis
  */
  sibling(elm1, elm2){ 
    if(elm1.parentNode == elm2.parentNode){ 
      return true; 
    } else { 
      return false; 
    }
  }

  /**
   * Cancel the current event
   * @param {event} the event.
   * @author David J. Davis
  */
  cancelEvent(event) {
    if (typeof event.cancelable !== 'boolean' || event.cancelable) {
      event.preventDefault();
    } else {
      console.warn(`The following event couldn't be canceled:`);
      console.dir(event);
    }
    return false; 
  }

  /**
   * Make sure that the elements are valid to return.
   * @param {event} the event.
   * @author David J. Davis
  */
  validationChecks(){ 
    if(this.grabbedElm == null || this.elms == null) {
      return false; 
    } else { 
      return true; 
    }
  }

  // ========================================================================
  // EVENTS
  // ========================================================================

  /**
   * Grabs the element and sets the drag in motion
   * Attaches to dragstart
   * @author David J. Davis
  */
  start(event) {
    event.stopPropagation();
    this.setGrabbed(event.target);
    this.setElmList();
    event.dataTransfer.setData('dataID', event.target.dataset.id);
    event.target.classList.add('dragging');
    event.dataTransfer.effectAllowed = "move";
  }

  /**
   * This event is the collision of elements and how the drag/drop works.
   * Attaches to dragover
   * @author David J. Davis
  */
  collision(event) {
    event.stopPropagation();
    if (!this.validationChecks()) { return; } // nothing to do if not valid 

    let eventObj = event.target;
    let eventObjIndex = this.getIndexOfElm(eventObj, this.elms); 
    let dragElmIndex = this.getIndexOfElm(this.grabbedElm, this.elms);

    if(this.sibling(this.grabbedElm, eventObj)){ 
      if(eventObjIndex < dragElmIndex){
        event.target.parentNode.insertBefore( this.grabbedElm, eventObj); 
      } else { 
         event.target.parentNode.insertBefore(this.grabbedElm, eventObj.nextSibling)
      }
    }
  }

  /**
   * Exit Collision
   * Attaches to dragleave event
   * @author David J. Davis
  */
  exitCollision(event){ 
    event.preventDefault();
  }

  /**
   * Does the actual dragging event
   * Attaches to mousemove, drag, touchmove
   * @author David J. Davis
  */
  drag(event) { 
    event.stopPropagation(); 
    event.preventDefault();
  } 

  /**
   * Drops the element 
   * Attaches to mouseup, dragend
   * @author David J. Davis
  */
  drop(event) {
    // needs query again because dom has reset
    let elms = this.container.querySelectorAll(this.sortElmClass);

    elms.forEach(function(elm, index) {
      let sortNum = (index + 1)
      let json = JSON.parse(elm.dataset.json.replace(/'/g, '"'));
      // set the active field element to the proper order or it will cause other problems.
      if(elm.classList.contains('active')){ 
        document.getElementById('sort_order').value = sortNum; 
      }
      elm.dataset.sort = sortNum; 
      json['sort_order'] = sortNum; 

      elm.dataset.json = JSON.stringify(json).replace(/"/g, "'");
    }); 

    // resets
    this.unsetGrabbed(); 
    this.unsetElmList();
    event.stopPropagation();
    event.preventDefault(); 
  }

  /**
   * SortUp event that attaches to an up arrow button.
   * This is to be more accessible alternative sorting method.
   * @author David J. Davis
  */
  sortUp(event){ 
    event.preventDefault();
    event.stopPropagation();
    let sortElm = event.target.parentNode.parentNode; 
    let sortOrder = sortElm.dataset['sort'];
    if(sortElm.previousElementSibling != null){ 
      sortElm.dataset.sort = parseInt(sortOrder) - 1; 
      sortElm.previousElementSibling.dataset.sort = parseInt(sortElm.previousElementSibling.dataset['sort']) + 1; 
    } 
    this.sortPreview(); 
  }

  /**
   * SortDown event that attaches to a down arrow button.
   * This is to be more accessible alternative sorting method.
   * @author David J. Davis
  */
  sortDown(event){ 
    event.preventDefault();
    event.stopPropagation();
    let sortElm = event.target.parentNode.parentNode; 
    let sortOrder = sortElm.dataset['sort'];
    if(sortElm.nextElementSibling != null){ 
      sortElm.dataset.sort = parseInt(sortOrder) + 1; 
      sortElm.nextElementSibling.dataset.sort = parseInt(sortElm.nextElementSibling.dataset['sort']) - 1; 
    } 
    this.sortPreview(); 
  }


  // ========================================================================
  // DOM CHANGES
  // ========================================================================

  /**
   * Changes the DOM to represent the new proper sorting order for 
   * the elements that have an affected sort column. 
   * @author David J. Davis
  */
  sortPreview(){ 
    let elements = Array.from(this.container.children); 
    let sorted = elements.sort(function(a,b){ 
      return +a.dataset.sort - +b.dataset.sort
    });

    this.container.innerHTML = '';
    sorted.forEach(elm => this.container.append(elm));
    let formSettings = document.querySelector('.formSettingsBtn'); 
    click(formSettings);
  }
}