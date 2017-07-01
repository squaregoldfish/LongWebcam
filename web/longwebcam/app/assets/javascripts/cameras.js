// Page global variables
var map = null;
var mapSource = null;
var searchResults = null;
var searchResultsMapLayer = null;
var onLoadRun = false;

// Page load JS. Decides what to do based on the page contents
$(document).on('turbolinks:load', function () {
  if (!onLoadRun) {
    if ($('#searchMap').length) {
      drawSearchMap();
    }

    if ($('#searchForm').length) {
      $('#searchForm').on('ajax:success', function(e, data, status, xhr) {
        searchResults = JSON.parse(xhr.responseText);
        drawSearchResults();  
      });
      bindingsAdded = true;
    }

    $('#searchForm').submit();

    onLoadRun = true;
  }
});

function drawSearchMap() {
	if (null == map) {
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
}

function drawSearchResults() {
  drawMapSearchResults();
}

function drawMapSearchResults() {
  if (null != searchResultsMapLayer) {
    map.removeLayer(searchResultsMapLayer);
    searchResultsMapLayer = null;
  }

  var cameraFeatures = new Array(searchResults.length);

  for (var i = 0; i < searchResults.length; i++) {
    var camera = searchResults[i];
    cameraFeatures[i] = new ol.Feature({
      geometry: new ol.geom.Point([camera['longitude'], camera['latitude']]).transform(ol.proj.get("EPSG:4326"), mapSource.getProjection()),
      name: camera['title'],
      imageUrl: camera['url']
    }); 
  }

  searchResultsMapLayer = new ol.layer.Vector({
    source: new ol.source.Vector({
      features: cameraFeatures
    }),
    style: new ol.style.Style({
      image: new ol.style.Icon({
          src: '/assets/camera_icon.png'
      })
    })
  });

  map.addLayer(searchResultsMapLayer);
}
