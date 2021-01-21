export default function forceKeyUp(elem){ 
  elem.dispatchEvent(new KeyboardEvent('keyup',{'key':'a'}));
};
