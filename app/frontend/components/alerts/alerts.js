import './alerts.scss'; 

document.addEventListener('click', function(event){
  if(event.target.className == "close-img"){ 
    event.target.parentNode.parentNode.remove();
  }
});