export default function click(elem){ 
  let evt = new MouseEvent('click', {
    bubbles: true,
    cancelable: true,
    view: window
  });
  let canceled = !elem.dispatchEvent(evt);
};