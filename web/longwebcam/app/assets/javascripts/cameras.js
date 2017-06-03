// Page load JS. Decides what to do based on the page contents
$(document).on('turbolinks:load', function (){
  if ($('#searchMap').length) {
    drawSearchMap();
  }
});

function drawSearchMap() {
	mapSource = new ol.source.Stamen({
  		layer: "terrain",
  		url: "https://stamen-tiles-{a-d}.a.ssl.fastly.net/terrain/{z}/{x}/{y}.png"
	});

	map = new ol.Map({
 		target: 'searchMap',
 		layers: [
    		new ol.layer.Tile({
        		source: mapSource
    		})
  		],
  		view: new ol.View({
    		center: ol.proj.fromLonLat([10, 45]),
    		zoom: 4,
    		minZoom: 2
  		})
	});
}
