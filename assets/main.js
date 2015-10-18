(function(){
  var listItems = document.getElementsByClassName('list-group-item');
  var codeLinkers = ['PRE', 'CODE', 'A'];

  // make clicking on list item open to plot unless it's a link to the code
  Array.prototype.forEach.call(listItems, function(item){
    if(typeof item.dataset.plot == 'string'){
      item.addEventListener('click', function(clickEvent){
        if(codeLinkers.indexOf(clickEvent.target.nodeName) == -1){
          clickEvent.preventDefault();
          window.open(item.dataset.plot, '_new');
        }
      });
    }
  });
}());
