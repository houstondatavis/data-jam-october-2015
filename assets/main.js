(function(){
  var listItems = document.getElementsByClassName('list-group-item');
  var codeLinkers = ['PRE', 'CODE', 'A'];

  var plotterSVG = document.getElementsByClassName('plotter');
  var PLOTTER_HEIGHT = 50;
  var BARS_WIDTH = 20;
  var BARS_SPACING = 4;

  var rectDOM = document.createElement('rect');
  rectDOM.setAttribute('fill', 'rgba(0, 0, 0, 0.02)');

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

  Array.prototype.forEach.call(plotterSVG, function(plotter){
    var grapher = plotter.children[0];
    var numberOfBars = Math.floor(plotter.clientWidth / (BARS_WIDTH + BARS_SPACING));

    var counter = 0;
    var barsHTML = '';

    plotter.setAttribute('viewBox',((plotter.clientWidth/2) - (BARS_WIDTH + BARS_SPACING)) + ' 0 50 50');

    while(counter < numberOfBars){
      var bar = rectDOM.cloneNode();

      var rectHeight = Math.random() * PLOTTER_HEIGHT;

      bar.setAttribute('width', BARS_WIDTH);
      bar.setAttribute('height', rectHeight);
      bar.setAttribute('x', counter * (BARS_WIDTH + BARS_SPACING));
      bar.setAttribute('y', PLOTTER_HEIGHT - rectHeight);

      barsHTML += bar.outerHTML;
      counter ++;
    }

    grapher.innerHTML = barsHTML;
  });

}());
