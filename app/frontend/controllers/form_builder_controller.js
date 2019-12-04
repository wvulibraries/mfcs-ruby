import {Controller} from "stimulus";
import Validation from "../components/validation/validation";

export default class extends Controller {
  // targets
  static targets = []

  add(e) { 
    e.preventDefault(); 
    console.log('is this button working');
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